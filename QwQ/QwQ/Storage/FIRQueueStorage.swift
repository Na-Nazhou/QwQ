import FirebaseFirestore
import Foundation
import os.log

class FIRQueueStorage: CustomerQueueStorage {
    // MARK: Storage as singleton
    static let shared = FIRQueueStorage()

    private init() {}

    // MARK: Storage capabilities
    private let db = Firestore.firestore()
    private var queuesDb: CollectionReference {
        db.collection(Constants.queuesDirectory)
    }

    private let logicDelegates = NSHashTable<AnyObject>.weakObjects()

    private var listener: ListenerRegistration?

    deinit {
        removeListener()
    }

    private func getQueueRecordDocument(record: QueueRecord) -> DocumentReference {
        queuesDb.document(record.id)
    }

    func addQueueRecords(newRecords: [QueueRecord], completion: @escaping () -> Void) {
        let batch = db.batch()
        for newRecord in newRecords {
            let newRecordRef = getQueueRecordDocument(record: newRecord)
            batch.setData(newRecord.dictionary, forDocument: newRecordRef)
        }
        batch.commit { err in
            if let err = err {
                os_log("Error adding queue record",
                       log: Log.addQueueRecordError,
                       type: .error,
                       err.localizedDescription)
                return
            }
            completion()
        }
    }

    func updateQueueRecord(oldRecord: QueueRecord, newRecord: QueueRecord,
                           completion: @escaping () -> Void) {
        let oldDocRef = getQueueRecordDocument(record: oldRecord)
        oldDocRef.setData(newRecord.dictionary) { (error) in
                if let error = error {
                    os_log("Error updating queue record",
                           log: Log.updateQueueRecordError,
                           type: .error,
                           error.localizedDescription)
                    return
                }
            completion()
        }
    }

    func updateQueueRecords(newRecords: [QueueRecord], completion: @escaping () -> Void) {
        let batch = db.batch()
        for newRecord in newRecords {
            let newRecordRef = getQueueRecordDocument(record: newRecord)
            batch.setData(newRecord.dictionary, forDocument: newRecordRef)
        }
        batch.commit { err in
             if let err = err {
                os_log("Error updating queue record",
                       log: Log.updateQueueRecordError,
                       type: .error,
                       err.localizedDescription)
                return
            }
            completion()
        }
    }
}

extension FIRQueueStorage {
    // MARK: - Listeners

    func registerListener(for customer: Customer) {
        removeListener()

        listener = queuesDb
            .whereField(Constants.customerKey, isEqualTo: customer.uid)
            .addSnapshotListener(includeMetadataChanges: false) { (snapshot, err) in
                guard let snapshot = snapshot, err == nil else {
                    os_log("Error getting queue record documents",
                           log: Log.queueRetrievalError,
                           type: .error,
                           String(describing: err))
                    return
                }

                snapshot.documentChanges.forEach { diff in
                    var completion: (QueueRecord) -> Void
                    switch diff.type {
                    case .added:
                        completion = { record in self.delegateWork { $0.didAddQueueRecord(record) } }
                    case .modified:
                        completion = { record in self.delegateWork { $0.didUpdateQueueRecord(record) } }
                    case .removed:
                        os_log("Detected removal of queue record from db which should not happen.",
                               log: Log.removeDbRecordError,
                               type: .error)
                        completion = { _ in }
                    }
                    self.makeQueueRecord(
                        document: diff.document,
                        completion: completion)
                }
            }
    }

    private func makeQueueRecord(document: DocumentSnapshot,
                                 completion: @escaping (QueueRecord) -> Void) {
        guard let data = document.data(),
            let rid = data[Constants.restaurantKey] as? String else {
            os_log("Error getting rid from Queue Record document.",
                   log: Log.ridError, type: .error)
            return
        }
        let qid = document.documentID

        FIRRestaurantInfoStorage.getRestaurantFromUID(uid: rid, completion: { restaurant in
            FIRProfileStorage.getCustomerInfo(
                completion: { customer in
                guard let rec = QueueRecord(dictionary: data,
                                            customer: customer,
                                            restaurant: restaurant,
                                            id: qid) else {
                                                os_log("Cannot create queue record. Maybe accidentally deleted.",
                                                       log: Log.createQueueRecordError,
                                                       type: .error)
                                                return
                    }
                    completion(rec)
                }, errorHandler: { _ in })
        }, errorHandler: nil)
    }

    func removeListener() {
        listener?.remove()
        listener = nil
    }
}

extension FIRQueueStorage {
    // MARK: - Delegates

    func registerDelegate(_ del: QueueStorageSyncDelegate) {
        logicDelegates.add(del)
    }

    func unregisterDelegate(_ del: QueueStorageSyncDelegate) {
        logicDelegates.remove(del)
    }

    private func delegateWork(doWork: (QueueStorageSyncDelegate) -> Void) {
        for delegate in logicDelegates.allObjects {
            guard let delegate = delegate as? QueueStorageSyncDelegate else {
                continue
            }
            doWork(delegate)
        }
    }
}

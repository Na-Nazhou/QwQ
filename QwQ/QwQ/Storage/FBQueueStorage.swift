import FirebaseFirestore
import Foundation
import os.log

class FBQueueStorage: CustomerQueueStorage {
    // MARK: Storage as singleton
    static let shared = FBQueueStorage()

    private init() {}

    // MARK: Storage capabilities
    private let db = Firestore.firestore()
    private var queuesDb: CollectionReference {
        db.collection(Constants.queuesDirectory)
    }

    let logicDelegates = NSHashTable<AnyObject>.weakObjects()

    private var listener: ListenerRegistration?

    deinit {
        listener?.remove()
    }

    private func getQueueRecordDocument(record: QueueRecord) -> DocumentReference {
        queuesDb.document(record.id)
    }

    func addQueueRecord(newRecord: QueueRecord, completion: @escaping (_ id: String) -> Void) {
        let newRecordRef = queuesDb.document()
        newRecordRef.setData(newRecord.dictionary) { (error) in
            if let error = error {
                os_log("Error adding queue record",
                       log: Log.addQueueRecordError,
                       type: .error,
                       error.localizedDescription)
                return
            }
            completion(newRecordRef.documentID)
        }
    }

    func updateQueueRecord(oldRecord: QueueRecord, newRecord: QueueRecord, completion: @escaping () -> Void) {
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

    func deleteQueueRecord(record: QueueRecord, completion: @escaping () -> Void) {
        let docRef = getQueueRecordDocument(record: record)
        docRef.delete { (error) in
                if let error = error {
                    os_log("Error deleting queue record",
                           log: Log.deleteQueueRecordError,
                           type: .error,
                           error.localizedDescription)
                    return
                }
            completion()
        }
    }

    // MARK: - Storage data retrieval
    func loadActiveQueueRecords(customer: Customer, completion: @escaping (QueueRecord?) -> Void) {
        os_log("Loading all active queue records (regardless of date); old ones shouldve been made history though.",
               log: Log.loadActivity, type: .info)
        queuesDb.whereField("customer", isEqualTo: customer.uid)
            //.whereField("startTime", isEqualTo: Date().toString())
            .getDocuments { (recordsSnapshot, err) in
            if let err = err {
                os_log("Error getting documents",
                       log: Log.activeQueueRetrievalError,
                       type: .error, String(describing: err))
                return
            }
            recordsSnapshot!.documents.forEach {
                self.makeQueueRecord(document: $0) { record in
                    if record.isActiveRecord {
                        completion(record)
                    }
                }
            }
        }
    }

    /// Searches for the customer's queue records in the past week (7 days) and
    /// calls the completion handler when records are found.
    func loadQueueHistory(customer: Customer, completion:  @escaping (QueueRecord?) -> Void) {
        queuesDb.whereField("customer", isEqualTo: customer.uid)
            .getDocuments { (recordsSnapshot, err) in
            if let err = err {
                os_log("Error getting documents", log: Log.queueRetrievalError, type: .error, String(describing: err))
                return
            }
                recordsSnapshot!.documents.forEach {
                    self.makeQueueRecord(document: $0) { record in
                        if record.isHistoryRecord {
                            completion(record)
                        }
                    }
                }
        }
    }

    private func makeQueueRecord(document: DocumentSnapshot,
                                 completion: @escaping (QueueRecord) -> Void) {
        guard let data = document.data(), let rid = data["restaurant"] as? String else {
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
                                                os_log("Couldn't create queue record. Likely a document is deleted but it's not supposed to.",
                                                       log: Log.createQueueRecordError, type: .info)
                                                return
                    }
                    completion(rec)
            }, errorHandler: { _ in })
        }, errorHandler: nil)
    }

    // MARK: - Listeners
    func registerListener(for customer: Customer) {
        removeListener()

        listener = queuesDb.whereField("customer", isEqualTo: customer.uid)
            .addSnapshotListener { (snapshot, err) in
            guard let snapshot = snapshot, err == nil else {
                os_log("Error getting documents", log: Log.queueRetrievalError, type: .error, String(describing: err))
                return
            }

                snapshot.documents.forEach {
                    self.makeQueueRecord(document: $0) { record in
                        self.delegateWork { $0.didUpdateQueueRecord(record) }
                    }
                }
        }
    }

    func removeListener() {
        listener?.remove()
        listener = nil
    }

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

//
//  FBQueueStorage.swift
//  QwQ-restaurant
//
//  Created by Happy on 16/3/20.
//

import FirebaseFirestore
import os.log

class FIRQueueStorage: RestaurantQueueStorage {
    // MARK: Storage as singleton
    static let shared = FIRQueueStorage()

    private init() {}

    // MARK: Storage capabilities
    private let db = Firestore.firestore()
    private var queueDb: CollectionReference {
        db.collection(Constants.queuesDirectory)
    }

    let logicDelegates = NSHashTable<AnyObject>.weakObjects()

    private var queueListener: ListenerRegistration?

    deinit {
        removeListener()
    }

    private func getQueueRecordDocument(record: QueueRecord) -> DocumentReference {
        queueDb.document(record.id)
    }

    func updateRecord(oldRecord: QueueRecord, newRecord: QueueRecord, completion: @escaping () -> Void) {
        let oldDocRef = getQueueRecordDocument(record: oldRecord)
        oldDocRef.setData(newRecord.dictionary) { err in
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

    func registerListener(for restaurant: Restaurant) {
        removeListener()
        queueListener = queueDb
            .whereField(Constants.restaurantKey, isEqualTo: restaurant.uid)
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
                    print("\n\tDetected removal of queue record from db which should not happen.\n")
                    completion = { _ in }
                }

                self.makeQueueRecord(
                    document: diff.document,
                    restaurant: restaurant,
                    completion: completion)
            }
        }
    }

    func removeListener() {
        queueListener?.remove()
        queueListener = nil
    }

    private func makeQueueRecord(document: DocumentSnapshot,
                                 restaurant: Restaurant,
                                 completion: @escaping (QueueRecord) -> Void) {
        guard let data = document.data(), let customerUID = data[Constants.customerKey] as? String else {
            os_log("Error getting cid from Queue Record document.",
                   log: Log.cidError, type: .error)
            return
        }

        let qid = document.documentID

        FIRCustomerStorage.getCustomerFromUID(uid: customerUID, completion: { customer in
                guard let rec = QueueRecord(dictionary: data,
                                            customer: customer,
                                            restaurant: restaurant,
                                            id: qid) else {
                                                os_log("Cannot create queue record.",
                                                       log: Log.createQueueRecordError, type: .error)
                                                return
                    }
                    completion(rec)
                }, errorHandler: { _ in })
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

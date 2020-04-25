import FirebaseFirestore
import os.log

/// A Firestore-based storage handler for queues. Reads and writes to Firestore and listens to changes to
/// documents in Firestore.
class FIRQueueStorage: RestaurantQueueStorage {
    // MARK: Storage as singleton
    static let shared = FIRQueueStorage()

    private init() {}

    // MARK: Storage capabilities
    private let db = Firestore.firestore()
    private var queueDb: CollectionReference {
        db.collection(Constants.queuesDirectory)
    }

    private let logicDelegates = NSHashTable<AnyObject>.weakObjects()

    private var queueListener: ListenerRegistration?

    deinit {
        removeListener()
    }

    private func getQueueRecordDocument(record: QueueRecord) -> DocumentReference {
        queueDb.document(record.id)
    }
    
    /// Updates a queue record from `oldRecord` to `newRecord` in Firestore.
    /// - Parameters:
    ///     - oldRecord: outdated record.
    ///     - newRecord: updated record.
    ///     - completion: procedure to perform when the record is updated on Firestore.
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
    
    /// Updates multiple queue records in Firestore.
    /// - Parameters:
    ///     - newRecords: updated records to be updated to.
    ///     - completion: procedure to perform when all new records are written.
    func updateRecords(newRecords: [QueueRecord], completion: @escaping () -> Void) {
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
    
    /// Register to listen to all queue records of `restaurant`.
    func registerListener(for restaurant: Restaurant) {
        removeListener()
        queueListener = queueDb
            .whereField(Constants.restaurantKey, isEqualTo: restaurant.uid)
            .addSnapshotListener(includeMetadataChanges: false) { (snapshot, err) in
            guard let snapshot = snapshot, err == nil else {
                os_log("Error getting queue record documents", log: Log.queueRetrievalError,
                       type: .error, String(describing: err))
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
                           log: Log.unexpectedDiffError, type: .error)
                    completion = { _ in }
                }

                self.makeQueueRecord(
                    document: diff.document,
                    restaurant: restaurant,
                    completion: completion)
            }
            }
    }
    
    /// Removes any registered listener.
    func removeListener() {
        queueListener?.remove()
        queueListener = nil
    }
    
    /// Generates and uses the queue record from the Firestore queue record document.
    /// - Parameters:
    ///     - document: Firestore queue record document
    ///     - completion: procedure to perform on the `QueueRecord` upon generating a valid `QueueRecord`
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
    
    /// Register `del` as a delegate of this component.
    func registerDelegate(_ del: QueueStorageSyncDelegate) {
        logicDelegates.add(del)
    }
    
    /// Unregister `del` from this component.
    func unregisterDelegate(_ del: QueueStorageSyncDelegate) {
        logicDelegates.remove(del)
    }
    
    /// Delegates all registered delegates to do work.
    private func delegateWork(doWork: (QueueStorageSyncDelegate) -> Void) {
        for delegate in logicDelegates.allObjects {
            guard let delegate = delegate as? QueueStorageSyncDelegate else {
                continue
            }
            doWork(delegate)
        }
    }
}

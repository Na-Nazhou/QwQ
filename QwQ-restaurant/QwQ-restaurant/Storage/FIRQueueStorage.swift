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
    private var restaurantDb: CollectionReference {
        db.collection(Constants.restaurantsDirectory)
    }

    let logicDelegates = NSHashTable<AnyObject>.weakObjects()

    private var openCloseListener: ListenerRegistration?
    private var queueListener: ListenerRegistration?

    deinit {
        removeListeners()
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

    func registerListeners(for restaurant: Restaurant) {
        removeListeners()
        registerListenerForQueue(of: restaurant)
        registerListenerForRestaurant(restaurant)
    }

    func removeListeners() {
        openCloseListener?.remove()
        queueListener?.remove()
        openCloseListener = nil
        queueListener = nil
    }

    private func registerListenerForQueue(of restaurant: Restaurant) {
        queueListener = queueDb
            .whereField(Constants.restaurantKey, isEqualTo: restaurant.uid)
            .addSnapshotListener { (snapshot, err) in
                guard let snapshot = snapshot, err == nil else {
                    print("Error fetching documents: \(String(describing: err))")
                    return
                }
                snapshot.documentChanges.forEach { diff in
                    var completion: (QueueRecord) -> Void
                    switch diff.type {
                    case .added:
                        print("\n\tfound new q\n")
                        completion = { record in self.delegateWork { $0.didAddQueueRecord(record) } }
                    case .modified:
                        print("\n\tfound update q\n")
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

    private func registerListenerForRestaurant(_ restaurant: Restaurant) {
        openCloseListener = restaurantDb.document(restaurant.uid)
            .addSnapshotListener { (profileSnapshot, err) in
                if let err = err {
                    print("Error fetching document: \(err)")
                    return
                }
                guard let profileData = profileSnapshot!.data(),
                    let updatedRestaurant = Restaurant(dictionary: profileData) else {
                        assert(false, "document should be of correct format(fields) of a restaurant!")
                        return
                }
                // regardless of change, contact delegate it has changed.
                self.delegateWork { $0.restaurantDidPossiblyChangeQueueStatus(restaurant: updatedRestaurant) }
            }
    }

    private func makeQueueRecord(document: DocumentSnapshot,
                                 restaurant: Restaurant,
                                 completion: @escaping (QueueRecord) -> Void) {
        guard let data = document.data(), let cid = data[Constants.customerKey] as? String else {
            os_log("Error getting cid from Queue Record document.",
                   log: Log.cidError, type: .error)
            return
        }
        let qid = document.documentID

        FIRCustomerInfoStorage.getCustomerFromUID(uid: cid, completion: { customer in
                guard let rec = QueueRecord(dictionary: data,
                                            customer: customer,
                                            restaurant: restaurant,
                                            id: qid) else {
                                                os_log("Cannot create queue record.",
                                                       log: Log.createQueueRecordError, type: .info)
                                                return
                    }
                    completion(rec)
                }, errorHandler: { _ in })
    }

    private func getQueueRecordDocument(record: QueueRecord) -> DocumentReference {
        queueDb.document(record.id)
    }

    func updateRecord(oldRecord: QueueRecord, newRecord: QueueRecord, completion: @escaping () -> Void) {
        let oldDocRef = getQueueRecordDocument(record: oldRecord)
        oldDocRef.setData(newRecord.dictionary) { error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            completion()
        }
    }

    func updateRestaurantQueueStatus(old: Restaurant, new: Restaurant) {
        restaurantDb.document(old.uid)
            .setData(new.dictionary)
    }
}

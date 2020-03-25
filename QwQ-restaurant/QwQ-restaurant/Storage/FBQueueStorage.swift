//
//  FBQueueStorage.swift
//  QwQ-restaurant
//
//  Created by Happy on 16/3/20.
//

import FirebaseFirestore

class FBQueueStorage: RestaurantQueueStorage {

    let db = Firestore.firestore()

    weak var logicDelegate: QueueStorageSyncDelegate?
    
    init(restaurant: Restaurant) {
        attachListenerOnRestaurantQueue(restaurant: restaurant)
    }

    private func attachListenerOnRestaurantQueue(restaurant: Restaurant) {
        //listen to restaurant's queue document for 'today'
        //assuming users will restart app everyday
        let today = Date().toDateStringWithoutTime()
        db.collection(Constants.queuesDirectory)
            .document(restaurant.uid)
            .collection(today)
            .addSnapshotListener { (queueSnapshot, err) in
                if let err = err {
                    print("Error fetching documents: \(err)")
                    return
                }
                queueSnapshot!.documentChanges.forEach { diff in
                    var completion: (QueueRecord) -> Void
                    switch diff.type {
                    case .added:
                        print("\n\tfound new q\n")
                        completion = { self.logicDelegate?.didUpdateQueueRecord($0) }
                    case .modified:
                        completion = { self.logicDelegate?.didUpdateQueueRecord($0) }
                    case .removed:
                        print("\n\tcustomer deleted q themselves!\n")
                        completion = { self.logicDelegate?.didDeleteQueueRecord($0) }
                    }

                    guard let customer = diff.document.data()["customer"] as? String else {
                        assert(false, "all docs, including removed ones, should contain non empty data..?")
                        return
                    }
                    self.makeQueueRecord(
                        data: diff.document.data(), ofQid: diff.document.documentID,
                        forCid: customer, atRestaurant: restaurant, completion: completion)
                }
            }
    }

    private func makeQueueRecord(
        data: [String: Any], ofQid qid: String, forCid cid: String,
        atRestaurant restaurant: Restaurant,
        completion: @escaping (QueueRecord) -> Void) {
        FBCustomerInfoStorage.getCustomerFromUID(uid: cid, completion: { customer in
            guard let rec = QueueRecord(dictionary: data, customer: customer, restaurant: restaurant, id: qid) else {
                return
            }
            completion(rec)
            }, errorHandler: nil)
    }

    func updateRecord(oldRecord: QueueRecord, newRecord: QueueRecord, completion: @escaping () -> Void) {
        db.collection(Constants.queuesDirectory)
            .document(oldRecord.restaurant.uid)
            .collection(oldRecord.startDate)
            .document(oldRecord.id)
            .setData(newRecord.dictionary) { _ in
                completion()
        }
    }

    func updateRestaurantQueueStatus(old: Restaurant, new: Restaurant) {
        db.collection(Constants.restaurantsDirectory)
            .document(old.uid)
            .setData(new.dictionary)
    }

    func loadQueue(of restaurant: Restaurant, completion: @escaping (QueueRecord?) -> Void) {
        loadQueueRecords(of: restaurant, where: { $0.isPendingAdmission }, completion: completion)
    }
    
    func loadWaitingList(of restaurant: Restaurant, completion: @escaping (QueueRecord?) -> Void) {
        loadQueueRecords(of: restaurant, where: { $0.isAdmitted }, completion: completion)
    }
    
    private func loadQueueRecords(of restaurant: Restaurant,
                                  where condition: @escaping (QueueRecord) -> Bool,
                                  completion: @escaping (QueueRecord?) -> Void) {
        db.collection(Constants.queuesDirectory)
            .document(restaurant.uid)
            .collection(Date().toDateStringWithoutTime())
            .getDocuments { (queueSnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                    return
                }
                for document in queueSnapshot!.documents {
                    guard let cid = document.data()["customer"] as? String else {
                        return
                    }
                    FBCustomerInfoStorage.getCustomerFromUID(uid: cid, completion: { customer in
                        guard let rec = QueueRecord(dictionary: document.data(),
                                                    customer: customer, restaurant: restaurant,
                                                    id: document.documentID) else {
                                                        return
                        }
                        if condition(rec) {
                            completion(rec)
                        }
                    }, errorHandler: nil)
                }
            }
    }
}

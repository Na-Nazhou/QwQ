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
        registerListenerForQueue(restaurant: restaurant)
        registerListenerForRestaurant(restaurant: restaurant)
    }

    private func registerListenerForQueue(restaurant: Restaurant) {
        // listen to restaurant's queue document for 'today'
        // assuming users will restart app everyday
        let today = Date.getFormattedDate(date: Date(), format: Constants.recordDateFormat)
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
                        completion = { self.logicDelegate?.didAddQueueRecord($0) }
                    case .modified:
                        print("\n\tfound update q\n")
                        completion = { self.logicDelegate?.didUpdateQueueRecord($0) }
                    case .removed:
                        print("\n\tcustomer deleted q themselves!\n")
                        completion = { self.logicDelegate?.didDeleteQueueRecord($0) }
                    }

                    guard let customerUID = diff.document.data()["customer"] as? String else {
                        assert(false, "all docs, including removed ones, should contain non empty data..?")
                        return
                    }
                    self.makeQueueRecord(
                        data: diff.document.data(), id: diff.document.documentID,
                        customerUID: customerUID, restaurant: restaurant,
                        completion: completion)
                }
            }
    }

    private func registerListenerForRestaurant(restaurant: Restaurant) {
        db.collection(Constants.restaurantsDirectory)
            .document(restaurant.uid)
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
                self.logicDelegate?.restaurantDidPossiblyChangeQueueStatus(restaurant: updatedRestaurant)
            }
    }

    private func makeQueueRecord(
        data: [String: Any], id: String, customerUID: String,
        restaurant: Restaurant,
        completion: @escaping (QueueRecord) -> Void) {
        FBCustomerInfoStorage.getCustomerFromUID(uid: customerUID, completion: { customer in
            guard let rec = QueueRecord(dictionary: data, customer: customer, restaurant: restaurant, id: id) else {
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
    
    private func loadQueueRecords(of restaurant: Restaurant,
                                  where condition: @escaping (QueueRecord) -> Bool,
                                  completion: @escaping (QueueRecord?) -> Void) {
        db.collection(Constants.queuesDirectory)
            .document(restaurant.uid)
            .collection(Date.getFormattedDate(date: Date(), format: Constants.recordDateFormat))
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
                                                    customer: customer,
                                                    restaurant: restaurant,
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

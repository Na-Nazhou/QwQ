//
//  FBQueueStorage.swift
//  QwQ-restaurant
//
//  Created by Happy on 16/3/20.
//

import FirebaseFirestore

class FBQueueStorage: RestaurantQueueStorage {

    let db = Firestore.firestore()

    weak var queueModificationLogicDelegate: QueueStorageSyncDelegate?
    
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
                        //customerDidJoinQueue
                        print("\n\tfound new q\n")
                        completion = { self.queueModificationLogicDelegate?.customerDidJoinQueue(with: $0) }
                    case .modified:
                        //customerDidUpdateInfo
                        //or restaurantDidChangeCustomerQueueStatus
                        completion = {
                            switch self.getUpdateType(of: $0) {
                            case .admit:
                                self.queueModificationLogicDelegate?.restaurantDidAdmitCustomer(record: $0)
                            case .reject:
                                self.queueModificationLogicDelegate?.restaurantDidRejectCustomer(record: $0)
                            case .serve:
                                self.queueModificationLogicDelegate?.restaurantDidServeCustomer(record: $0)
                            case .customerUpdate:
                                self.queueModificationLogicDelegate?.customerDidUpdateQueueRecord(to: $0)
                            }
                        }
                    case .removed:
                        //customerDidQuitQueue
                        print("\n\tcustomer deleted q themselves!\n")
                        completion = { self.queueModificationLogicDelegate?.customerDidWithdrawQueue(record: $0) }
                    }
                    guard let customer = diff.document.data()["customer"] as? String else {
                        assert(false, "all docs, including removed ones, should contain non empty data..?")
                        return
                    }
                    self.getQueueRecordAndComplete(
                        data: diff.document.data(), ofQid: diff.document.documentID,
                        forCid: customer, atRestaurant: restaurant, completion: completion)
                }
            }
        
        //listen to restaurant's profile
    }

    private func getUpdateType(of rec: QueueRecord) -> RecordModification {
        if rec.admitTime == nil {
            print("\n\tmodif is update!\n")
            return .customerUpdate
        }
        if rec.serveTime != nil {
            print("\n\tmodif is serve!\n")
            return .serve
        }
        if rec.rejectTime != nil {
            print("\n\tmodif is reject!\n")
            return .reject
        }
        print("\n\tmodif is admit!?\n")
        return .admit
    }

    private func getQueueRecordAndComplete(
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

    // Time should have been checked to be valid before passing in.
    func openQueue(of restaurant: Restaurant, at time: Date) {
        var updatedRestaurant = restaurant
        updatedRestaurant.queueOpenTime = time
        
        db.collection("restaurants")
            .document(restaurant.uid)
            .setData(updatedRestaurant.dictionary)
    }

    func closeQueue(of restaurant: Restaurant, at time: Date) {
        var updatedRestaurant = restaurant
        updatedRestaurant.queueCloseTime = time
        db.collection("restaurants")
            .document(restaurant.uid)
            .setData(updatedRestaurant.dictionary)
    }
    
    // Record admit time already updated before being passed in.
    func admitCustomer(record: QueueRecord) {
        updateRecord(record: record)
    }
    
    func serveCustomer(record: QueueRecord) {
        updateRecord(record: record)
    }
    
    func rejectCustomer(record: QueueRecord) {
        updateRecord(record: record)
    }

    private func updateRecord(record: QueueRecord) {
        db.collection("queues")
          .document(record.restaurant.uid)
          .collection(record.startDate)
          .document(record.id)
            .setData(record.dictionary)
    }
    
    func loadQueue(of restaurant: Restaurant, completion: @escaping (QueueRecord?) -> Void) {
        loadQueueRecords(of: restaurant, where: { $0.isPendingAdmission }, completion: completion)
    }
    
    func loadWaitingList(of restaurant: Restaurant, completion: @escaping (QueueRecord?) -> Void) {
        loadQueueRecords(of: restaurant, where: { $0.isAdmitted }, completion: completion)
    }
    
    private func loadQueueRecords(of restaurant: Restaurant, where condition: @escaping (QueueRecord) -> Bool,
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
    
    func didDetectNewQueueRecord(record: QueueRecord) {
        queueModificationLogicDelegate?.customerDidJoinQueue(with: record)
    }
    
    func didDetectQueueRecordUpdate(new: QueueRecord) {
        queueModificationLogicDelegate?.customerDidUpdateQueueRecord(to: new)
    }
    
    func didDetectWithdrawnQueueRecord(record: QueueRecord) {
        
    }
    
    func didDetectAdmissionOfCustomer(record: QueueRecord) {
        
    }
    
    func didDetectServiceOfCustomer(record: QueueRecord) {
        
    }
    
    func didDetectRejectionOfCustomer(record: QueueRecord) {
        
    }
    
    func didDetectOpenQueue(restaurant: Restaurant) {
        
    }
    
    func didDetectCloseQueue(restaurant: Restaurant) {
        
    }
}

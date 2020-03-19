//
//  FBQueueStorage.swift
//  QwQ-restaurant
//
//  Created by Happy on 16/3/20.
//

import FirebaseFirestore

class FBQueueStorage: RestaurantQueueStorage {
    let db: Firestore
    weak var queueModificationLogicDelegate: QueueStorageSyncDelegate?
    weak var queueStatusLogicDelegate: QueueOpenCloseSyncDelegate?
    
    init() {
        self.db = Firestore.firestore()
        attachListenerOnRestaurantData()
    }

    private func attachListenerOnRestaurantData() {
        //listen to restaurant's queue document for 'today'
        //listen to restaurant's profile
    }

    // Time should have been checked to be valid before passing in.
    func openQueue(of restaurant: Restaurant, at time: Date) {
        var updatedRestaurant = restaurant
        updatedRestaurant.queueOpenTime = time
        
        db.collection("restaurants")
            .document(restaurant.uid)
            .setData(Restaurant.restaurantToDictionary(updatedRestaurant))
    }

    func closeQueue(of restaurant: Restaurant, at time: Date) {
        var updatedRestaurant = restaurant
        updatedRestaurant.queueCloseTime = time
        db.collection("restaurants")
            .document(restaurant.uid)
            .setData(Restaurant.restaurantToDictionary(updatedRestaurant))
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
          .setData(QueueRecord.queueRecordToDictionary(record))
    }
    
    func loadQueue(of restaurant: Restaurant, completion: @escaping (QueueRecord?) -> Void) {
        loadQueueRecords(of: restaurant, where: { $0.isUnadmittedQueueingRecord }, completion: completion)
    }
    
    func loadWaitingList(of restaurant: Restaurant, completion: @escaping (QueueRecord?) -> Void) {
        loadQueueRecords(of: restaurant, where: { $0.isWaitingRecord }, completion: completion)
    }
    
    private func loadQueueRecords(of restaurant: Restaurant, where condition: @escaping (QueueRecord) -> Bool,
                                  completion: @escaping (QueueRecord?) -> Void) {
        db.collection("queues")
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

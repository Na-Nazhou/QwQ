//
//  FBQueueStorage.swift
//  QwQ
//
//  Created by Daniel Wong on 12/3/20.
//

import FirebaseFirestore
import Foundation

class FBQueueStorage: CustomerQueueStorage {

    let db: Firestore

    weak var queueModificationLogicDelegate: QueueStorageSyncDelegate?
    weak var queueStatusLogicDelegate: QueueOpenCloseSyncDelegate?

    init() {
        self.db = Firestore.firestore()
    }

    func addQueueRecord(record: QueueRecord, completion: @escaping (String) -> Void) {
        // Attach listener
        let newQueueRecordRef = db.collection("queues")
            .document(record.restaurant.uid)
            .collection(record.startDate)
            .document()
        newQueueRecordRef.setData(QueueRecord.queueRecordToDictionary(record)) { (error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            completion(newQueueRecordRef.documentID)
        }
    }

    func updateQueueRecord(old: QueueRecord, new: QueueRecord, completion: @escaping () -> Void) {
        db.collection("queues")
            .document(new.restaurant.uid)
            .collection(old.startDate)
            .document(old.id)
            .setData(QueueRecord.queueRecordToDictionary(new)) { (error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                completion()
            }
    }

    func deleteQueueRecord(record: QueueRecord, completion: @escaping () -> Void) {
        db.collection("queues")
            .document(record.restaurant.uid)
            .collection(record.startDate)
            .document(record.id)
            .delete { (error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                completion()
            }
    }

    // MARK: - Protocol conformance
    
    func loadQueueRecord(customer: Customer, completion: @escaping (QueueRecord?) -> Void) {

        // TODO: Attach listener

        db.collection("queues").getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let restaurantQueuesToday = self.db.collection("queues")
                        .document(document.documentID)
                        .collection(Date().toDateStringWithoutTime())
                    restaurantQueuesToday.getDocuments { (queueSnapshot, err) in
                        if let err = err {
                            print("Error getting documents: \(err)")
                        } else {
                            self.triggerCompletionIfRecordWithConditionFoundInRestaurantQueues(
                                queueSnapshot: queueSnapshot!,
                                forCustomer: customer,
                                condition: { dict in
                                    if dict["serveTime"] as? Timestamp != nil
                                        || dict["rejectTime"] as? Timestamp != nil {
                                    return false //already served/rejected = past queue history
                                }
                                return true
                                }, completion: completion)
                        }
                    }
                }
            }
        }
    }

    /// Searches for the customer's queue records in the past week (7 days) and
    /// calls the completion handler when records are found.
    func loadQueueHistory(customer: Customer, completion:  @escaping (QueueRecord?) -> Void) {
        db.collection("queues").getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    for numDaysAgo in 0...6 {
                        let rQueue = self.db.collection("queues").document(document.documentID)
                            .collection(Date().getDateOf(daysBeforeDate: numDaysAgo).toDateStringWithoutTime())
                        rQueue.getDocuments { (queueSnapshot, err) in
                            if let err = err {
                                print("Error getting documents: \(err)")
                            } else {
                                self
                                    .triggerCompletionIfRecordWithConditionFoundInRestaurantQueues(
                                        queueSnapshot: queueSnapshot!, forCustomer: customer,
                                        condition: { dict in
                                            if dict["serveTime"] as? Timestamp != nil
                                                || dict["rejectTime"] as? Timestamp != nil {
                                                return true //over=> past history
                                            }
                                            return false
                                        }, completion: completion)
                            }
                        }
                    }
                }
            }
        }
    }

    private func triggerCompletionIfRecordWithConditionFoundInRestaurantQueues(
        queueSnapshot: QuerySnapshot, forCustomer customer: Customer,
        condition: (([String: Any]) -> Bool), completion: @escaping (QueueRecord?) -> Void) {
        for document in queueSnapshot.documents {
            guard let qCid = (document.data()["customer"] as? String), qCid == customer.uid else {
                return
            }
            if condition(document.data()) {
                completion(QueueRecord(dictionary: document.data()))
            }
        }
    }

//    // MARK: - Protocol conformance
//
//    func loadQueueRecord(customer: Customer, completion: @escaping (QueueRecord?) -> Void) {
//        // Attach listener
//        completion(nil)
//    }
//
//    func loadQueueHistory(customer: Customer, completion:  @escaping ([QueueRecord]) -> Void) {
//        // TODO
//        let restaurant = Restaurant(uid: "1",
//                                    name: "history queue record",
//                                    email: "restaurant@gmail.com",
//                                    contact: "98721234",
//                                    address: "address",
//                                    menu: "menu",
//                                    isOpen: true)
//        let customer = Customer(uid: "2", name: "name", email: "name@", contact: "9827")
//        let record1 = QueueRecord(restaurant: restaurant,
//                                  customer: customer,
//                                  groupSize: 2,
//                                  babyChairQuantity: 1,
//                                  wheelchairFriendly: false,
//                                  startTime: Date(),
//                                  admitTime: Date())
//        let queueHistory = [record1]
//        completion(queueHistory)
//    }
    
    func didDetectAdmissionOfCustomer(record: QueueRecord) {
        queueModificationLogicDelegate?.restaurantDidAdmitCustomer(record: record)
    }
    
    func didDetectRejectionOfCustomer(record: QueueRecord) {
        queueModificationLogicDelegate?.restaurantDidRejectCustomer(record: record)
    }
    
    func didDetectOpenQueue(restaurant: Restaurant) {
        queueStatusLogicDelegate?.restaurantDidOpenQueue(restaurant: restaurant)
    }
    
    func didDetectCloseQueue(restaurant: Restaurant) {
        queueStatusLogicDelegate?.restaurantDidCloseQueue(restaurant: restaurant)
    }

}

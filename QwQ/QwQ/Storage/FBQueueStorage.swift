//
//  FBQueueStorage.swift
//  QwQ
//
//  Created by Daniel Wong on 12/3/20.
//

import FirebaseFirestore

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
        newQueueRecordRef.setData(queueRecordToDictionary(record)) { (error) in
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
            .setData(queueRecordToDictionary(new)) { (error) in
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
            .delete() { (error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                completion()
        }
    }

    private func queueRecordToDictionary(_ record: QueueRecord) -> [String: Any] {
        var data = [String: Any]()
        data["customer"] = record.customer.uid
        data["groupSize"] = record.groupSize
        data["babyChairQuantity"] = record.babyChairQuantity
        data["wheelchairFriendly"] = record.wheelchairFriendly
        data["startTime"] = record.startTime

        if let admitTime = record.admitTime {
            data["admitTime"] = admitTime
        }

        return data
    }

    // MARK: - Protocl conformance
    
    func loadQueueRecord(customer: Customer) -> QueueRecord? {
        // Attach listener
        return nil
    }

    func loadQueueHistory(customer: Customer) -> [QueueRecord] {
        // Attach listener
        return []
    }
    
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

//var customer: Customer
//var restaurant: Restaurant
//
//var groupSize: Int
//var babyCount: Int
//var wheelchairCount: Int
//
//var startTime: Date
//var serveTime: Date?

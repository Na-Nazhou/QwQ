//
//  FBQueueStorage.swift
//  QwQ
//
//  Created by Daniel Wong on 12/3/20.
//

import FirebaseFirestore

class FBQueueStorage: CustomerQueueStorage {
    let db: Firestore
    var date: String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "ddMMyyyy"
        return formatter.string(from: date)
    }

    init() {
        self.db = Firestore.firestore()
    }

    func addQueueRecord(record: QueueRecord) {
        db.collection("queues")
            .document(record.restaurant.uid)
            .collection(date)
            .addDocument(data: queueRecordToDictionary(record)) { (error) in
                if let error = error {
                    print(error.localizedDescription)
                }
            }
    }

    func updateQueueRecord(old: QueueRecord, new: QueueRecord) {
        db.collection("queues")
            .document(new.restaurant.uid)
            .collection(date).document("")
            .setData(queueRecordToDictionary(new)) { (error) in
                if let error = error {
                    print(error.localizedDescription)
                }
            }
    }

    func deleteQueueRecord(record: QueueRecord) {
        db.collection("queues")
            .document(record.restaurant.uid)
            .collection(date)
            .document("")
            .delete()
    }

    private func queueRecordToDictionary(_ record: QueueRecord) -> [String: Any] {
        var data = [String: Any]()
        data["customer"] = record.customer.uid
        data["groupSize"] = record.groupSize
        data["babyChairQuantity"] = record.babyChairQuantity
        data["wheelchairFriendly"] = record.wheelchairFriendly
        data["startTime"] = record.startTime

        if let serveTime = record.serveTime {
            data["serveTime"] = serveTime
        }

        return data
    }

    // MARK: - Protocl conformance
    
    func loadQueueRecord(customer: Customer) -> QueueRecord? {
        return nil
    }
    
    weak var queueModificationLogicDelegate: QueueStorageSyncDelegate?
    weak var queueStatusLogicDelegate: QueueOpenCloseSyncDelegate?
    
    func didDetectNewQueueRecord(record: QueueRecord) {

    }
    
    func didDetectQueueRecordUpdate(old: QueueRecord, new: QueueRecord) {

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

//var customer: Customer
//var restaurant: Restaurant
//
//var groupSize: Int
//var babyCount: Int
//var wheelchairCount: Int
//
//var startTime: Date
//var serveTime: Date?

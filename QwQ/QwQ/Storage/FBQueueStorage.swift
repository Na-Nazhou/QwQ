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

    func removeQueueRecord(record: QueueRecord) {
        db.collection("queues")
            .document(record.restaurant.uid)
            .collection(date)
            .document("")
            .delete()
    }

    func updateQueueRecord(record: QueueRecord) {
        db.collection("queues")
            .document(record.restaurant.uid)
            .collection(date).document("")
            .setData(queueRecordToDictionary(record)) { (error) in
                if let error = error {
                    print(error.localizedDescription)
                }
            }
    }

    private func queueRecordToDictionary(_ record: QueueRecord) -> [String: Any] {
        var data = [String: Any]()
        data["customer"] = record.customer.uid
        data["groupSize"] = record.groupSize
        data["babyCount"] = record.babyCount
        data["wheelchairCount"] = record.wheelchairCount
        data["startTime"] = record.startTime

        if let serveTime = record.serveTime {
            data["serveTime"] = serveTime
        }

        return data
    }

    // MARK: - Protocl conformance
    
    func updateQueueRecord(old: QueueRecord, new: QueueRecord) {
        
    }
    
    func deleteQueueRecord(record: QueueRecord) {
        
    }
    
    func loadQueueRecord() -> QueueRecord? {
        return nil
    }
    
    var queueModificationLogicDelegate: QueueStorageSyncDelegate?
    
    var queueStatusLogicDelegate: QueueOpenCloseSyncDelegate?
    
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
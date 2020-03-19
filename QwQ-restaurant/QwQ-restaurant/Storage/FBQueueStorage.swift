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

    func openQueue(of restaurant: Restaurant, at time: Date) {
//        let newQueueRecordRef = db.collection("restaurants")
//            .document(restaurant.uid)
//        newQueueRecordRef.setData(queueRecordToDictionary(record)) { (error) in
//            if let error = error {
//                print(error.localizedDescription)
//                return
//            }
//            completion(newQueueRecordRef.documentID)
//        }
    }
    
    func closeQueue(of restaurant: Restaurant, at time: Date) {
        
    }
    
    func admitCustomer(record: QueueRecord) {
        
    }
    
    func removeCustomerFromQueue(record: QueueRecord) {
        
    }
    
    func serveCustomer(record: QueueRecord) {
        
    }
    
    func rejectCustomer(record: QueueRecord) {
        
    }
    
    func loadQueue(of restaurant: Restaurant) -> [QueueRecord] {
        []
    }
    
    func loadWaitingList(of restaurant: Restaurant) -> [QueueRecord] {
        []
    }

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

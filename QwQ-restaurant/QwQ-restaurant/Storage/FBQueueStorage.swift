//
//  FBQueueStorage.swift
//  QwQ-restaurant
//
//  Created by Happy on 16/3/20.
//

import FirebaseFirestore

class FBQueueStorage: RestaurantQueueStorage {
    let db: Firestore
    var queueModificationLogicDelegate: QueueStorageSyncDelegate?
    var queueStatusLogicDelegate: QueueOpenCloseSyncDelegate?
    
    init() {
        self.db = Firestore.firestore()
        attachListenerOnRestaurantData()
    }

    private func attachListenerOnRestaurantData() {
        //listen to restaurant's queue document for 'today'
        //listen to restaurant's profile
    }

    func openQueue(of restaurant: Restaurant, at time: Date) {
        let restaurantDoc = db.collection("restaurants")
            .document(restaurant.uid)
        restaurantDoc.setData(restaurantToDictionary(restaurant))
    }

    private func restaurantToDictionary(_ restaurant: Restaurant) -> [String: Any] {
        var data = [String: Any]()
        data["uid"] = restaurant.uid
        data["name"] = restaurant.name
        data["email"] = restaurant.email
        data["contact"] = restaurant.contact
        data["address"] = restaurant.address
        data["menu"] = restaurant.menu
        data["isOpen"] = restaurant.isOpen
        return data
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
        return []
    }
    
    func loadWaitingList(of restaurant: Restaurant) -> [QueueRecord] {
        return []
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

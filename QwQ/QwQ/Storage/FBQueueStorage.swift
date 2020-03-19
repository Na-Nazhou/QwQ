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

        //ensure that all collections/documents exist
        db.collection(Constants.queuesDirectory).document(record.restaurant.uid).setData([:], merge: true)
        let newQueueRecordRef = db.collection(Constants.queuesDirectory)
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
        db.collection(Constants.queuesDirectory)
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
        db.collection(Constants.queuesDirectory)
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

        db.collection(Constants.queuesDirectory).getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                return
            }
            for document in querySnapshot!.documents {
                let restaurantQueuesToday = self.db.collection(Constants.queuesDirectory)
                    .document(document.documentID)
                    .collection(Date().toDateStringWithoutTime())
                restaurantQueuesToday.getDocuments { (queueSnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    }
                    self.triggerCompletionIfRecordWithConditionFoundInRestaurantQueues(
                        queueSnapshot: queueSnapshot!, ofRestaurantId: document.documentID,
                        forCustomer: customer,
                        isRecordToTake: { !$0.isHistoryRecord
                        }, completion: completion)
                }
            }
        }
    }

    /// Searches for the customer's queue records in the past week (7 days) and
    /// calls the completion handler when records are found.
    func loadQueueHistory(customer: Customer, completion:  @escaping (QueueRecord?) -> Void) {
        db.collection(Constants.queuesDirectory).getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                return
            }
            for document in querySnapshot!.documents {
                for numDaysAgo in 0...6 {
                    let rQueue = self.db.collection(Constants.queuesDirectory).document(document.documentID)
                        .collection(Date().getDateOf(daysBeforeDate: numDaysAgo).toDateStringWithoutTime())
                    rQueue.getDocuments { (queueSnapshot, err) in
                        if let err = err {
                            print("Error getting documents: \(err)")
                            return
                        }
                        if queueSnapshot!.isEmpty {
                            return
                        }
                        self
                            .triggerCompletionIfRecordWithConditionFoundInRestaurantQueues(
                                queueSnapshot: queueSnapshot!, ofRestaurantId: document.documentID,
                                forCustomer: customer,
                                isRecordToTake: { $0.isHistoryRecord
                                }, completion: completion)
                    }
                }
            }
        }
    }

    private func triggerCompletionIfRecordWithConditionFoundInRestaurantQueues(
        queueSnapshot: QuerySnapshot, ofRestaurantId rId: String, forCustomer customer: Customer,
        isRecordToTake condition: @escaping ((QueueRecord) -> Bool), completion: @escaping (QueueRecord?) -> Void) {
        for document in queueSnapshot.documents {
            guard let qCid = (document.data()["customer"] as? String), qCid == customer.uid else {
                continue
            }

            makeQueueRecordAndComplete(qData: document.data(), qid: document.documentID, cid: qCid, rid: rId) { qRec in
                if condition(qRec) {
                    completion(qRec)
                }
            }
        }
    }

    private func makeQueueRecordAndComplete(qData: [String: Any],
                                            qid: String, cid: String, rid: String,
                                            completion: @escaping (QueueRecord) -> Void) {
        FBRestaurantInfoStorage.getRestaurantFromUID(uid: rid, completion: { restaurant in
            FBProfileStorage.getCustomerInfo(
                completion: { customer in
                guard let rec = QueueRecord(dictionary: qData,
                                            customer: customer, restaurant: restaurant, id: qid) else {
                    return
                }
                completion(rec)
                }, errorHandler: { _ in })
            
        }, errorHandler: nil)
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

import FirebaseFirestore
import Foundation

class FBQueueStorage: CustomerQueueStorage {

    let db: Firestore

    weak var queueModificationLogicDelegate: QueueStorageSyncDelegate?
    weak var queueStatusLogicDelegate: QueueOpenCloseSyncDelegate?

    private var listener: ListenerRegistration?

    init() {
        self.db = Firestore.firestore()
    }

    func addQueueRecord(record: QueueRecord, completion: @escaping (String) -> Void) {
        //create document if it doesn't exist (non-existent container)
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

    // MARK: - Storage data retrieval
    func loadQueueRecord(customer: Customer, completion: @escaping (QueueRecord?) -> Void) {

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
                    queueSnapshot!.documents.forEach {
                        self.triggerCompletionIfRecordWithConditionFoundInRestaurantQueues(
                            queueRecData: $0.data(), docId: $0.documentID,
                            ofRestaurantId: document.documentID, forCustomerId: customer.uid,
                            isRecordToTake: { !$0.isHistoryRecord }, completion: completion)
                    }
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
                        queueSnapshot!.documents.forEach {
                            self.triggerCompletionIfRecordWithConditionFoundInRestaurantQueues(
                                queueRecData: $0.data(), docId: $0.documentID,
                                ofRestaurantId: document.documentID, forCustomerId: customer.uid,
                                isRecordToTake: { $0.isHistoryRecord }, completion: completion)
                        }
                    }
                }
            }
        }
    }

    private func triggerCompletionIfRecordWithConditionFoundInRestaurantQueues(
        queueRecData: [String: Any], docId: String,
        ofRestaurantId rId: String, forCustomerId cid: String,
        isRecordToTake condition: @escaping ((QueueRecord) -> Bool), completion: @escaping (QueueRecord?) -> Void) {
        guard let qCid = (queueRecData["customer"] as? String), qCid == cid else {
            return
        }

        makeQueueRecordAndComplete(qData: queueRecData, qid: docId, cid: qCid, rid: rId) { qRec in
            if condition(qRec) {
                completion(qRec)
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

    // MARK: - Listeners
    func listenOnlyToCurrentRecord(_ rec: QueueRecord) {
        //remove any listeners
        listener?.remove()
        listener = nil
        //add listener
        listener = db.collection(Constants.queuesDirectory).document(rec.restaurant.uid)
            .collection(rec.startDate).document(rec.id)
            .addSnapshotListener { (qRecSnapshot, err) in
            guard let qRecDocument = qRecSnapshot, err == nil else {
                print("Error fetching document: \(err!)!")
                return
            }
            guard let qRecData = qRecDocument.data() else {
                self.queueModificationLogicDelegate?.customerDidDeleteActiveQueueRecord()
                return
            }
            self.triggerCompletionIfRecordWithConditionFoundInRestaurantQueues(
                queueRecData: qRecData, docId: qRecDocument.documentID,
                ofRestaurantId: rec.restaurant.uid, forCustomerId: rec.customer.uid,
                isRecordToTake: { _ in true }, completion: {
                assert($0 != nil, "qRecord data should be valid.")
                self.queueModificationLogicDelegate?.queueRecordDidUpdate($0!)
                })
            }
    }
    
    func removeListener() {
        listener?.remove()
        listener = nil
    }
    
    func didDetectOpenQueue(restaurant: Restaurant) {
        queueStatusLogicDelegate?.restaurantDidOpenQueue(restaurant: restaurant)
    }
    
    func didDetectCloseQueue(restaurant: Restaurant) {
        queueStatusLogicDelegate?.restaurantDidCloseQueue(restaurant: restaurant)
    }

}

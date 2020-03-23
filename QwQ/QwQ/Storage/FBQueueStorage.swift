import FirebaseFirestore
import Foundation

class FBQueueStorage: CustomerQueueStorage {

    let db = Firestore.firestore()

    weak var queueModificationLogicDelegate: QueueStorageSyncDelegate?

    private var listener: ListenerRegistration?
    private var isFirstResponse = true

    private func getQueueRecordDocument(record: QueueRecord) -> DocumentReference {
        db.collection(Constants.queuesDirectory)
            .document(record.restaurant.uid)
            .collection(record.startDate)
            .document(record.id)
    }

    func addQueueRecord(newRecord: QueueRecord, completion: @escaping (_ id: String) -> Void) {
        //create document if it doesn't exist (non-existent container)
        db.collection(Constants.queuesDirectory).document(newRecord.restaurant.uid).setData([:], merge: true)
        let newQueueRecordRef = db.collection(Constants.queuesDirectory)
            .document(newRecord.restaurant.uid)
            .collection(newRecord.startDate)
            .document()
        newQueueRecordRef.setData(newRecord.dictionary) { (error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            completion(newQueueRecordRef.documentID)
        }
    }

    func updateQueueRecord(oldRecord: QueueRecord, newRecord: QueueRecord, completion: @escaping () -> Void) {
        let oldDocRef = getQueueRecordDocument(record: oldRecord)
        oldDocRef.setData(newRecord.dictionary) { (error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                completion()
        }
    }

    func deleteQueueRecord(record: QueueRecord, completion: @escaping () -> Void) {
        let docRef = getQueueRecordDocument(record: record)
        docRef.delete { (error) in
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
                            docRef: $0,
                            ofRestaurantId: document.documentID, forCustomerId: customer.uid,
                            where: { !$0.isHistoryRecord }, completion: completion)
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
                    let rQueue = self.db.collection(Constants.queuesDirectory)
                        .document(document.documentID)
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
                                docRef: $0,
                                ofRestaurantId: document.documentID, forCustomerId: customer.uid,
                                where: { $0.isHistoryRecord }, completion: completion)
                        }
                    }
                }
            }
        }
    }

    private func triggerCompletionIfRecordWithConditionFoundInRestaurantQueues(
        docRef: DocumentSnapshot,
        ofRestaurantId rId: String, forCustomerId cid: String,
        where condition: @escaping (QueueRecord) -> Bool,
        completion: @escaping (QueueRecord?) -> Void) {

        let docId = docRef.documentID
        guard let queueRecData = docRef.data(),
            let qCid = (queueRecData["customer"] as? String),
            qCid == cid else {
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
                                            customer: customer, restaurant: restaurant,
                                            id: qid) else {
                    return
                }
                completion(rec)
                }, errorHandler: { _ in })
            
        }, errorHandler: nil)
    }

    // MARK: - Listeners
    func listenOnlyToCurrentRecord(_ record: QueueRecord) {
        //remove any listeners
        removeListener()

        //add listener
        let docRef = getQueueRecordDocument(record: record)
        listener = docRef.addSnapshotListener { (qRecSnapshot, err) in
            guard let qRecDocument = qRecSnapshot, err == nil else {
                print("Error fetching document: \(err!)!")
                return
            }

            guard !qRecDocument.metadata.hasPendingWrites else {
                return
            }

            if self.isFirstResponse {
                self.isFirstResponse = false
                return
            }

            guard let qRecData = qRecDocument.data() else {
                self.queueModificationLogicDelegate?.didDeleteActiveQueueRecord()
                return
            }

            guard let newRecord = QueueRecord(dictionary: qRecData,
                                              customer: record.customer,
                                              restaurant: record.restaurant,
                                              id: record.id) else {
                                            print("Error")
                                            return
            }
            self.queueModificationLogicDelegate?.didUpdateQueueRecord(newRecord)
        }
    }
    
    func removeListener() {
        guard listener != nil else {
            return
        }

        listener?.remove()
        listener = nil
        isFirstResponse = true
    }
}

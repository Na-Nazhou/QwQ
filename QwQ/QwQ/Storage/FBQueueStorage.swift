import FirebaseFirestore
import Foundation

class FBQueueStorage: CustomerQueueStorage {

    let db = Firestore.firestore()

    weak var logicDelegate: QueueStorageSyncDelegate?

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
    func loadActiveQueueRecords(customer: Customer, completion: @escaping (QueueRecord?) -> Void) {

        db.collection(Constants.queuesDirectory).getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                return
            }
            for document in querySnapshot!.documents {
                let restaurantQueuesToday = self.db.collection(Constants.queuesDirectory)
                    .document(document.documentID)
                    .collection(Date.getFormattedDate(date: Date(), format: Constants.recordDateFormat))
                restaurantQueuesToday.getDocuments { (queueSnapshot, err) in
                    if let err = err {
                        print("Error getting documents: \(err)")
                    }
                    queueSnapshot!.documents.forEach {
                        self.triggerCompletionIfRecordWithConditionFoundInRestaurantQueues(
                            docSnapshot: $0,
                            restaurantUID: document.documentID, forCustomerId: customer.uid,
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
                        .collection(Date.getFormattedDate(date: Date().getDateOf(daysBeforeDate: numDaysAgo),
                                                          format: Constants.recordDateFormat))
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
                                docSnapshot: $0,
                                restaurantUID: document.documentID,
                                forCustomerId: customer.uid,
                                where: { $0.isHistoryRecord }, completion: completion)
                        }
                    }
                }
            }
        }
    }

    private func triggerCompletionIfRecordWithConditionFoundInRestaurantQueues(
        docSnapshot: DocumentSnapshot,
        restaurantUID: String, forCustomerId cid: String,
        where condition: @escaping (QueueRecord) -> Bool,
        completion: @escaping (QueueRecord?) -> Void) {

        let docId = docSnapshot.documentID
        guard let data = docSnapshot.data(),
            let customerUID = (data["customer"] as? String),
            customerUID == cid else {
            return
        }

        makeQueueRecord(data: data,
                        id: docId,
                        customerUID: customerUID,
                        restaurantUID: restaurantUID) { record in
            if condition(record) {
                completion(record)
            }
        }
    }

    private func makeQueueRecord(data: [String: Any],
                                 id: String,
                                 customerUID: String,
                                 restaurantUID: String,
                                 completion: @escaping (QueueRecord) -> Void) {
        FIRRestaurantInfoStorage.getRestaurantFromUID(uid: restaurantUID, completion: { restaurant in
            FIRProfileStorage.getCustomerInfo(
                completion: { customer in
                guard let rec = QueueRecord(dictionary: data,
                                            customer: customer, restaurant: restaurant,
                                            id: id) else {
                    return
                }
                completion(rec)
                }, errorHandler: { _ in })

        }, errorHandler: nil)
    }

    // MARK: - Listeners
    func registerListener(for record: QueueRecord) {
        //remove any listeners
        removeListener(for: record)

        //add listener
        let docRef = getQueueRecordDocument(record: record)
        listener = docRef.addSnapshotListener { (snapshot, err) in
            guard let snapshot = snapshot, err == nil else {
                print("Error fetching document: \(err!)!")
                return
            }

            if self.isFirstResponse {
                self.isFirstResponse = false
                return
            }

            guard let data = snapshot.data() else {
                self.logicDelegate?.didDeleteQueueRecord(record)
                return
            }

            guard let newRecord = QueueRecord(dictionary: data,
                                              customer: record.customer,
                                              restaurant: record.restaurant,
                                              id: record.id) else {
                                            print("Error")
                                            return
            }
            self.logicDelegate?.didUpdateQueueRecord(newRecord)
        }
    }

    func removeListener(for record: QueueRecord) {
        guard listener != nil else {
            return
        }

        listener?.remove()
        listener = nil
        isFirstResponse = true
    }
}

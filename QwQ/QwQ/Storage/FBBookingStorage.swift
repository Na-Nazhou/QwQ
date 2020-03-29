import FirebaseFirestore
import Foundation
import os.log

class FBBookingStorage: CustomerBookingStorage {
    // MARK: Storage as singleton
    static let shared = FBBookingStorage()

    private init() {}

    // MARK: Storage capabilities
    private let db = Firestore.firestore()
    private var bookingDb: CollectionReference {
        db.collection(Constants.bookingsDirectory)
    }

    let logicDelegates = NSHashTable<AnyObject>.weakObjects()

    private var listener: ListenerRegistration?

    deinit {
        listener?.remove()
    }

    private func getBookRecordDocument(record: BookRecord) -> DocumentReference {
        bookingDb.document(record.id)
    }

    func addBookRecord(newRecord: BookRecord) {
        let newRecordRef = bookingDb.document()
        newRecordRef.setData(newRecord.dictionary) { (error) in
            if let error = error {
                os_log("Error adding book record",
                       log: Log.addBookRecordError,
                       type: .error,
                       error.localizedDescription)
                return
            }
        }
    }

    func updateBookRecord(oldRecord: BookRecord, newRecord: BookRecord) {
        let oldDocRef = getBookRecordDocument(record: oldRecord)
        oldDocRef.setData(newRecord.dictionary) { (error) in
                if let error = error {
                    os_log("Error updating book record",
                           log: Log.updateBookRecordError,
                           type: .error,
                           error.localizedDescription)
                    return
                }
        }
    }

    func loadActiveBookRecords(customer: Customer, completion: @escaping (BookRecord?) -> Void) {
        let startTime = Date.getCurrentTime().getDateOf(daysBeforeDate: 6)
        let startTimestamp = Timestamp(date: startTime)
        bookingDb.whereField("customer", isEqualTo: customer.uid)
            .whereField("time", isGreaterThanOrEqualTo: startTimestamp)
            .getDocuments { (querySnapshot, err) in
                if let err = err {
                    os_log("Error getting documents",
                           log: Log.activeBookRetrievalError,
                           type: .error,
                           String(describing: err))
                    return
                }
                for document in querySnapshot!.documents {
                    self.makeBookRecord(document: document) {
                        if !$0.isHistoryRecord {
                            completion($0)
                        }
                    }
                }
            }
    }

    func loadBookHistory(customer: Customer, completion: @escaping (BookRecord?) -> Void) {
        let startTime = Date.getCurrentTime().getDateOf(daysBeforeDate: 6)
        let startTimestamp = Timestamp(date: startTime)
        bookingDb.whereField("customer", isEqualTo: customer.uid)
            .whereField("time", isGreaterThanOrEqualTo: startTimestamp)
            .getDocuments { (querySnapshot, err) in
                if let err = err {
                    os_log("Error getting documents",
                           log: Log.bookRetrievalError,
                           type: .error,
                           String(describing: err))
                    return
                }
                for document in querySnapshot!.documents {
                    self.makeBookRecord(document: document) {
                        if $0.isHistoryRecord {
                            completion($0)
                        }
                    }
                }
            }
    }

    private func makeBookRecord(document: DocumentSnapshot, completion: @escaping (BookRecord) -> Void) {

        guard let data = document.data(),
            let rid = data["restaurant"] as? String else {
                os_log("Error getting rid from Book Record document.",
                       log: Log.ridError, type: .error)
            return
        }

        let bid = document.documentID

        FIRRestaurantInfoStorage.getRestaurantFromUID(uid: rid, completion: { restaurant in
            FIRProfileStorage.getCustomerInfo(
                completion: { customer in
                    guard let rec = BookRecord(dictionary: data,
                                               customer: customer,
                                               restaurant: restaurant,
                                               id: bid) else {
                                                   os_log("Couldn't create book record. Likely a document is deleted but it's not supposed to.",
                                                          log: Log.createBookRecordError, type: .info)
                                                return
                    }
                    completion(rec)
                }, errorHandler: { _ in })
        }, errorHandler: nil)
    }

    func registerListener(for customer: Customer) {
        removeListener()

        //add listener
        listener = bookingDb.whereField("customer", isEqualTo: customer.uid)
            .addSnapshotListener { (snapshot, err) in
            guard let snapshot = snapshot, err == nil else {
                os_log("Error getting documents", log: Log.bookRetrievalError, type: .error, String(describing: err))
                return
            }

                snapshot.documents.forEach {
                    self.makeBookRecord(document: $0) { record in
                        self.delegateWork { $0.didUpdateBookRecord(record) }
                    }
                }
        }
    }

    func removeListener() {
        listener?.remove()
        listener = nil
    }

    func registerDelegate(_ del: BookingStorageSyncDelegate) {
        logicDelegates.add(del)
    }

    func unregisterDelegate(_ del: BookingStorageSyncDelegate) {
        logicDelegates.remove(del)
    }

    private func delegateWork(doWork: (BookingStorageSyncDelegate) -> Void) {
        for delegate in logicDelegates.allObjects {
            guard let delegate = delegate as? BookingStorageSyncDelegate else {
                continue
            }
            doWork(delegate)
        }
    }
}

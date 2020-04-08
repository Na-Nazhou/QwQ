import FirebaseFirestore
import Foundation
import os.log

class FIRBookingStorage: CustomerBookingStorage {
    // MARK: Storage as singleton
    static let shared = FIRBookingStorage()

    private init() {}

    // MARK: Storage capabilities
    private let db = Firestore.firestore()
    private var bookingDb: CollectionReference {
        db.collection(Constants.bookingsDirectory)
    }

    let logicDelegates = NSHashTable<AnyObject>.weakObjects()

    private var listener: ListenerRegistration?

    deinit {
        removeListener()
    }

    private func getBookRecordDocument(record: BookRecord) -> DocumentReference {
        bookingDb.document(record.id)
    }

    func addBookRecord(newRecord: BookRecord, completion: @escaping () -> Void) {
        let newRecordRef = bookingDb.document()
        newRecordRef.setData(newRecord.dictionary) { (error) in
            if let error = error {
                os_log("Error adding book record",
                       log: Log.addBookRecordError,
                       type: .error,
                       error.localizedDescription)
                return
            }
            completion()
        }
    }

    func updateBookRecord(oldRecord: BookRecord, newRecord: BookRecord,
                          completion: @escaping () -> Void) {
        let oldDocRef = getBookRecordDocument(record: oldRecord)
        oldDocRef.setData(newRecord.dictionary) { (error) in
                if let error = error {
                    os_log("Error updating book record",
                           log: Log.updateBookRecordError,
                           type: .error,
                           error.localizedDescription)
                    return
                }
            completion()
        }
    }

    func updateBookRecords(newRecords: [BookRecord], completion: @escaping () -> Void) {
        let batch = db.batch()
        let recordDocPairs = newRecords.map {
            ($0, getBookRecordDocument(record: $0))
        }
        for (newRecord, docRef) in recordDocPairs {
            batch.setData(newRecord.dictionary, forDocument: docRef)
        }
        batch.commit { err in
            guard err == nil else {
                return
            }
            completion()
        }
    }

    private func makeBookRecord(document: DocumentSnapshot, completion: @escaping (BookRecord) -> Void) {

        guard let data = document.data(),
            let rid = data[Constants.restaurantKey] as? String else {
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
                                                          log: Log.createBookRecordError,
                                                          type: .error)
                                                return
                    }
                    completion(rec)
                }, errorHandler: { _ in })
        }, errorHandler: nil)
    }

    func removeListener() {
        listener?.remove()
        listener = nil
    }

    func registerListener(for customer: Customer) {
        removeListener()

        //add listener
        listener = bookingDb
            .whereField(Constants.customerKey, isEqualTo: customer.uid)
            .addSnapshotListener { (snapshot, err) in
                guard let snapshot = snapshot, err == nil else {
                    os_log("Error getting documents", log: Log.bookRetrievalError, type: .error, String(describing: err))
                    return
                }

                snapshot.documentChanges.forEach { diff in
                    var completion: (BookRecord) -> Void
                    switch diff.type {
                    case .added:
                        completion = { record in self.delegateWork { $0.didAddBookRecord(record) } }
                    case .modified:
                        completion = { record in self.delegateWork { $0.didUpdateBookRecord(record) } }
                    case .removed:
                        print("\n\tDetected removal of book record from db which should not happen.\n")
                        completion = { _ in }
                    }
                    self.makeBookRecord(
                        document: diff.document,
                        completion: completion)
                }
            }
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

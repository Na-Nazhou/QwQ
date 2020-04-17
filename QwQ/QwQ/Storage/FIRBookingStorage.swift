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

    func addBookRecords(newRecords: [BookRecord], completion: @escaping () -> Void) {
        let batch = db.batch()
        for newRecord in newRecords {
            let newRecordRef = getBookRecordDocument(record: newRecord)
            batch.setData(newRecord.dictionary, forDocument: newRecordRef)
        }
        batch.commit { err in
            if let err = err {
                os_log("Error adding book record",
                       log: Log.addBookRecordError,
                       type: .error,
                       err.localizedDescription)
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
        for newRecord in newRecords {
            let newRecordRef = getBookRecordDocument(record: newRecord)
            batch.setData(newRecord.dictionary, forDocument: newRecordRef)
        }
        batch.commit { err in
            if let err = err {
                os_log("Error updating book record",
                       log: Log.updateBookRecordError,
                       type: .error,
                       err.localizedDescription)
                return
            }
            completion()
        }
    }
}

extension FIRBookingStorage {
    // MARK: - Listeners

    func registerListener(for customer: Customer) {
        removeListener()

        //add listener
        listener = bookingDb
            .whereField(Constants.customerKey, isEqualTo: customer.uid)
            .addSnapshotListener(includeMetadataChanges: false) { (snapshot, err) in
                guard let snapshot = snapshot, err == nil else {
                    os_log("Error getting documents",
                           log: Log.bookRetrievalError,
                           type: .error,
                           String(describing: err))
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
                                                   os_log("Couldn't create book record.",
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
}

extension FIRBookingStorage {
    // MARK: - Delegates

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

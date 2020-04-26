import FirebaseFirestore
import Foundation
import os.log

/// A Firestore-based storage handler for bookings. Reads and writes to Firestore and listens to changes to
/// documents in Firestore.
class FIRBookingStorage: RestaurantBookingStorage {
    // MARK: Storage as singleton
    static let shared = FIRBookingStorage()

    private init() {}

    // MARK: Storage capabilities
    private let db = Firestore.firestore()
    private var bookingDb: CollectionReference {
        db.collection(Constants.bookingsDirectory)
    }

    private let logicDelegates = NSHashTable<AnyObject>.weakObjects()

    private var listener: ListenerRegistration?

    deinit {
        removeListener()
    }

    private func getBookRecordDocument(record: BookRecord) -> DocumentReference {
        db.collection(Constants.bookingsDirectory)
            .document(record.id)
    }
    
    /// Updates a book record from `oldRecord` to `newRecord` in Firestore.
    /// - Parameters:
    ///     - oldRecord: outdated record.
    ///     - newRecord: updated record.
    ///     - completion: procedure to perform when the record is updated on Firestore.
    func updateRecord(oldRecord: BookRecord, newRecord: BookRecord, completion: @escaping () -> Void) {
        let oldDocRef = getBookRecordDocument(record: oldRecord)
        oldDocRef.setData(newRecord.dictionary) { (err) in
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
    
    /// Updates multiple book records in Firestore.
    /// - Parameters:
    ///     - newRecords: updated records to be updated to.
    ///     - completion: procedure to perform when all new records are written.
    func updateRecords(newRecords: [BookRecord], completion: @escaping () -> Void) {
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
    
    /// Register to listen to all book records of `restaurant`.
    func registerListener(for restaurant: Restaurant) {
        removeListener()

        let date = Date()
        let calendar = Calendar.current
        let startTime = calendar.startOfDay(for: date)
        listener = db.collection(Constants.bookingsDirectory)
            .whereField(Constants.restaurantKey, isEqualTo: restaurant.uid)
            .whereField(Constants.timeKey, isGreaterThanOrEqualTo: startTime)
            .addSnapshotListener(includeMetadataChanges: false) { (snapshot, err) in
                guard let snapshot = snapshot, err == nil else {
                    os_log("Error getting book record documents", log: Log.bookRetrievalError,
                           type: .error, String(describing: err))
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
                        os_log("Detected removal of book record from db which should not happen.",
                               log: Log.unexpectedDiffError, type: .error)
                        completion = { _ in }
                    }

                    self.makeBookRecord(
                        document: diff.document,
                        restaurant: restaurant,
                        completion: completion)
                }
            }
    }
    
    /// Generates and uses the book record from the Firestore book record document.
    /// - Parameters:
    ///     - document: Firestore book record document
    ///     - completion: procedure to perform on the `BookRecord` upon generating a valid `BookRecord`
    private func makeBookRecord(document: DocumentSnapshot,
                                restaurant: Restaurant,
                                completion: @escaping (BookRecord) -> Void) {

        guard let data = document.data(),
            let customerUID = data[Constants.customerKey] as? String else {
                os_log("Error getting cid from Book Record document.",
                       log: Log.cidError, type: .error)
                return
        }

        let bid = document.documentID

        FIRCustomerStorage.getCustomerFromUID(uid: customerUID, completion: { customer in
            guard let rec = BookRecord(dictionary: data,
                                       customer: customer,
                                       restaurant: restaurant,
                                       id: bid) else {
                                        os_log("Cannot create book record.",
                                               log: Log.createBookRecordError,
                                               type: .error)
                                                return
                    }
                    completion(rec)
                }, errorHandler: { _ in })
    }
    
    /// Removes any registered listener.
    func removeListener() {
        listener?.remove()
        listener = nil
    }
}

extension FIRBookingStorage {
    // MARK: - Delegates
    
    /// Register `del` as a delegate of this component.
    func registerDelegate(_ del: BookingStorageSyncDelegate) {
        logicDelegates.add(del)
    }
    
    /// Unregister `del` from this component.
    func unregisterDelegate(_ del: BookingStorageSyncDelegate) {
        logicDelegates.remove(del)
    }
    
    /// Delegates all registered delegates to do work.
    private func delegateWork(doWork: (BookingStorageSyncDelegate) -> Void) {
        for delegate in logicDelegates.allObjects {
            guard let delegate = delegate as? BookingStorageSyncDelegate else {
                continue
            }
            doWork(delegate)
        }
    }
}

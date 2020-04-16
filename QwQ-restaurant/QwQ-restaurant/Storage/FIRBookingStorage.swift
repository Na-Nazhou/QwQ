//
//  FBBookingStorage.swift
//  QwQ-restaurant
//
//  Created by Nazhou Na on 25/3/20.
//

import FirebaseFirestore
import Foundation
import os.log

class FIRBookingStorage: RestaurantBookingStorage {
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
        db.collection(Constants.bookingsDirectory)
            .document(record.id)
    }

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
}

extension FIRBookingStorage {
    // MARK: - Listeners

    func registerListener(for restaurant: Restaurant) {
        removeListener()
        let date = Date()
        let calendar = Calendar.current
        let startTime = calendar.startOfDay(for: date)
        let startTimestamp = Timestamp(date: startTime)
        listener = db.collection(Constants.bookingsDirectory)
            .whereField(Constants.restaurantKey, isEqualTo: restaurant.uid)
            .whereField(Constants.timeKey, isGreaterThanOrEqualTo: startTimestamp)
            .addSnapshotListener(includeMetadataChanges: false) { (snapshot, err) in
                guard let snapshot = snapshot, err == nil else {
                    os_log("Error getting book record documents",
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
                        restaurant: restaurant,
                        completion: completion)
                }
            }
    }

    private func makeBookRecord(document: DocumentSnapshot,
                                restaurant: Restaurant,
                                completion: @escaping (BookRecord) -> Void) {

        guard let data = document.data(),
            let customerUID = data[Constants.customerKey] as? String else {
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

    func removeListener() {
        listener?.remove()
        listener = nil
    }
}

extension FIRBookingStorage {

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

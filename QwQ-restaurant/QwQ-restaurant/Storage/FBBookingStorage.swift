//
//  FBBookingStorage.swift
//  QwQ-restaurant
//
//  Created by Nazhou Na on 25/3/20.
//

import FirebaseFirestore
import Foundation
import os.log

class FBBookingStorage: RestaurantBookingStorage {
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
        removeListener()
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

    func registerListener(for restaurant: Restaurant) {
        removeListener()
        let date = Date()
        let calendar = Calendar.current
        let startTime = calendar.startOfDay(for: date)
        let startTimestamp = Timestamp(date: startTime)
        listener = db.collection(Constants.bookingsDirectory)
            .whereField("restaurant", isEqualTo: restaurant.uid)
            .whereField("time", isGreaterThanOrEqualTo: startTimestamp)
            .addSnapshotListener { (queueSnapshot, err) in
                if let err = err {
                    print("Error fetching documents: \(err)")
                    return
                }
                queueSnapshot!.documentChanges.forEach { diff in
                    var completion: (BookRecord) -> Void
                    switch diff.type {
                    case .added:
                        print("\n\tfound new b\n")
                        completion = { record in self.delegateWork { $0.didAddBookRecord(record) } }
                    case .modified:
                        print("\n\tfound update b\n")
                        completion = { record in self.delegateWork { $0.didUpdateBookRecord(record) } }
                    case .removed:
                        print("\n\tcustomer deleted b themselves!\n")
                        completion = { record in self.delegateWork { $0.didDeleteBookRecord(record) } }
                    }

                    self.makeBookRecord(
                        document: diff.document,
                        restaurant: restaurant,
                        completion: completion)
                }
            }
    }

    func removeListener() {
        listener?.remove()
        listener = nil
    }

    private func makeBookRecord(document: DocumentSnapshot,
                                restaurant: Restaurant,
                                completion: @escaping (BookRecord) -> Void) {

        guard let data = document.data(),
            let customerUID = data["customer"] as? String else {
            return
        }

        let bid = document.documentID
        FIRCustomerInfoStorage.getCustomerFromUID(uid: customerUID, completion: { customer in
                    guard let rec = BookRecord(dictionary: data,
                                               customer: customer,
                                               restaurant: restaurant,
                                               id: bid) else {
                                                return
                    }
                    completion(rec)
                }, errorHandler: { _ in })
    }

    private func getBookRecordDocument(record: BookRecord) -> DocumentReference {
        db.collection(Constants.bookingsDirectory)
            .document(record.id)
    }

    func updateRecord(oldRecord: BookRecord, newRecord: BookRecord, completion: @escaping () -> Void) {
        let oldDocRef = getBookRecordDocument(record: oldRecord)
        oldDocRef.setData(newRecord.dictionary) { (error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                completion()
        }
    }
}

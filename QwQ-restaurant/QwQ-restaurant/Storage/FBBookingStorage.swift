//
//  FBBookingStorage.swift
//  QwQ-restaurant
//
//  Created by Nazhou Na on 25/3/20.
//

import FirebaseFirestore
import Foundation

class FBBookingStorage: RestaurantBookingStorage {

    let db = Firestore.firestore()

    weak var logicDelegate: BookingStorageSyncDelegate?

    init(restaurant: Restaurant) {
        registerListenerForBooking(restaurant: restaurant)
    }

    private func registerListenerForBooking(restaurant: Restaurant) {
        // listen to restaurant's queue document for 'today'
        // assuming users will restart app everyday
        db.collection(Constants.bookingsDirectory)
            .whereField("restaurant", isEqualTo: restaurant.uid)
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
                        completion = { self.logicDelegate?.didAddBookRecord($0) }
                    case .modified:
                        print("\n\tfound update b\n")
                        completion = { self.logicDelegate?.didUpdateBookRecord($0) }
                    case .removed:
                        print("\n\tcustomer deleted b themselves!\n")
                        completion = { self.logicDelegate?.didDeleteBookRecord($0) }
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
            let customerUID = data["customer"] as? String else {
            return
        }

        let bid = document.documentID
        FBCustomerInfoStorage.getCustomerFromUID(uid: customerUID, completion: { customer in
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

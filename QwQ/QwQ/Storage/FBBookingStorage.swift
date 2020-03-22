//
//  FBBookingStorage.swift
//  QwQ
//
//  Created by Nazhou Na on 22/3/20.
//

import FirebaseFirestore
import Foundation

class FBBookingStorage: CustomerBookingStorage {

    let db = Firestore.firestore()

    weak var logicDelegate: BookingStorageSyncDelegate?

    func addBookRecord(record: BookRecord, completion: @escaping (String) -> Void) {
        db.collection(Constants.bookingsDirectory).document(record.restaurant.uid).setData([:], merge: true)
        let newRecordRef = db.collection(Constants.bookingsDirectory)
            .document(record.restaurant.uid)
            .collection(record.date)
            .document()
        newRecordRef.setData(record.dictionary) { (error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            completion(newRecordRef.documentID)
        }
    }

    func updateBookRecord(old: BookRecord, new: BookRecord, completion: @escaping () -> Void) {
        db.collection(Constants.bookingsDirectory)
            .document(new.restaurant.uid)
            .collection(old.date)
            .document(old.id)
            .setData(new.dictionary) { (error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                completion()
            }
    }

    func deleteBookRecord(record: BookRecord, completion: @escaping () -> Void) {
        db.collection(Constants.bookingsDirectory)
            .document(record.restaurant.uid)
            .collection(record.date)
            .document(record.id)
            .delete { (error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                completion()
            }
    }

    func loadActiveBookRecords(customer: Customer, completion: @escaping ([BookRecord]) -> Void) {
    }

    func loadBookHistory(customer: Customer, completion: @escaping ([BookRecord]) -> Void) {
    }
}

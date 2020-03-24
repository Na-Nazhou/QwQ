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

    private var listener: ListenerRegistration?
    private var isFirstResponse = true

    private func getBookRecordDocument(record: BookRecord) -> DocumentReference {
        db.collection(Constants.bookingsDirectory)
            .document(record.restaurant.uid)
            .collection(record.date)
            .document(record.id)
    }

    func addBookRecord(newRecord: BookRecord, completion: @escaping (_ id: String) -> Void) {
        //create document if it doesn't exist (non-existent container)
        db.collection(Constants.bookingsDirectory).document(newRecord.restaurant.uid).setData([:], merge: true)
        let newRecordRef = db.collection(Constants.bookingsDirectory)
            .document(newRecord.restaurant.uid)
            .collection(newRecord.date)
            .document()
        newRecordRef.setData(newRecord.dictionary) { (error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            completion(newRecordRef.documentID)
        }
    }

    func updateBookRecord(oldRecord: BookRecord, newRecord: BookRecord, completion: @escaping () -> Void) {
        let oldDocRef = getBookRecordDocument(record: oldRecord)
        oldDocRef.setData(newRecord.dictionary) { (error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                completion()
        }
    }

    func deleteBookRecord(record: BookRecord, completion: @escaping () -> Void) {
        let docRef = getBookRecordDocument(record: record)
        docRef.delete { (error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                completion()
        }
    }

    func loadActiveBookRecords(customer: Customer, completion: @escaping (BookRecord?) -> Void) {
    }

    func loadBookHistory(customer: Customer, completion: @escaping (BookRecord?) -> Void) {
    }

    func registerListener(for record: BookRecord) {
        // remove listener (if any)
        removeListener(for: record)

        //add listener
        let docRef = getBookRecordDocument(record: record)
        listener = docRef.addSnapshotListener { (qRecSnapshot, err) in
            guard let qRecDocument = qRecSnapshot, err == nil else {
                print("Error fetching document: \(err!)!")
                return
            }

            if self.isFirstResponse {
                self.isFirstResponse = false
                return
            }

            guard let qRecData = qRecDocument.data() else {
            self.logicDelegate?.didDeleteActiveBookRecord(record)
                return
            }

            guard let newRecord = BookRecord(dictionary: qRecData,
                                             customer: record.customer,
                                             restaurant: record.restaurant,
                                             id: record.id) else {
                                                print("Error")
                                                return
            }
            self.logicDelegate?.didUpdateBookRecord(newRecord)
        }

    }

    func removeListener(for record: BookRecord) {

    }
}

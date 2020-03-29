//
//  FBBookingStorage.swift
//  QwQ
//
//  Created by Nazhou Na on 22/3/20.
//

import FirebaseFirestore
import Foundation
import os.log

class FBBookingStorage: CustomerBookingStorage {

    let db = Firestore.firestore()

    weak var logicDelegate: BookingStorageSyncDelegate?

    private var listenerMap = [BookRecord: ListenerRegistration]()

    private func getBookRecordDocument(record: BookRecord) -> DocumentReference {
        db.collection(Constants.bookingsDirectory)
            .document(record.id)
    }

    func addBookRecord(newRecord: BookRecord, completion: @escaping (_ id: String) -> Void) {
        let newRecordRef = db.collection(Constants.bookingsDirectory)
            .document()
        newRecordRef.setData(newRecord.dictionary) { (error) in
            if let error = error {
                os_log("Error adding book record",
                       log: Log.addBookRecordError,
                       type: .error,
                       error.localizedDescription)
                return
            }
            completion(newRecordRef.documentID)
        }
    }

    func updateBookRecord(oldRecord: BookRecord, newRecord: BookRecord, completion: @escaping () -> Void) {
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

    func deleteBookRecord(record: BookRecord, completion: @escaping () -> Void) {
        let docRef = getBookRecordDocument(record: record)
        docRef.delete { (error) in
                if let error = error {
                    os_log("Error deleting book record",
                           log: Log.deleteBookRecordError,
                           type: .error,
                           error.localizedDescription)
                    return
                }
                completion()
        }
    }

    func loadActiveBookRecords(customer: Customer, completion: @escaping (BookRecord?) -> Void) {
        let startTime = Date().getDateOf(daysBeforeDate: 6)
        let startTimestamp = Timestamp(date: startTime)
        db.collection(Constants.bookingsDirectory)
            .whereField("customer", isEqualTo: customer.uid)
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
        let startTime = Date().getDateOf(daysBeforeDate: 6)
        let startTimestamp = Timestamp(date: startTime)
        db.collection(Constants.bookingsDirectory)
            .whereField("customer", isEqualTo: customer.uid)
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
                os_log("Error getting rid", log: Log.ridError, type: .error)
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
                                                return
                    }
                    completion(rec)
                }, errorHandler: { _ in })
        }, errorHandler: nil)
    }

    func registerListener(for record: BookRecord) {
        // remove listener (if any)
        removeListener(for: record)

        //add listener
        let docRef = getBookRecordDocument(record: record)
        let listener = docRef.addSnapshotListener { (snapshot, err) in
            guard let doc = snapshot, err == nil else {
                os_log("Error getting documents", log: Log.bookRetrievalError, type: .error, String(describing: err))
                return
            }

            guard let bookRecordData = doc.data() else {
                self.logicDelegate?.didDeleteBookRecord(record)
                return
            }

            guard let newRecord = BookRecord(dictionary: bookRecordData,
                                             customer: record.customer,
                                             restaurant: record.restaurant,
                                             id: record.id) else {
                                                os_log("Error creating book record",
                                                       log: Log.createBookRecordError,
                                                       type: .error,
                                                       String(describing: err))
                                                return
            }
            self.logicDelegate?.didUpdateBookRecord(newRecord)
        }
        listenerMap[record] = listener
    }

    func removeListener(for record: BookRecord) {
        listenerMap[record]?.remove()
        listenerMap[record] = nil
    }
}

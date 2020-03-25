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
        db.collection(Constants.bookingsDirectory)
            .whereField("customer", isEqualTo: customer.uid)
            .getDocuments { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
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
        db.collection(Constants.bookingsDirectory)
            .whereField("customer", isEqualTo: customer.uid)
            .getDocuments { (querySnapshot, err) in
                if let err = err {
                print("Error getting documents: \(err)")
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
            print("Error getting rid")
            return
        }

        let bid = document.documentID

        FBRestaurantInfoStorage.getRestaurantFromUID(uid: rid, completion: { restaurant in
            FBProfileStorage.getCustomerInfo(
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
       print("Adding listener for \(record)")
        let docRef = getBookRecordDocument(record: record)
        let listener = docRef.addSnapshotListener { (snapshot, err) in
            guard let doc = snapshot, err == nil else {
                print("Error fetching document: \(err!)!")
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
                                                print("Error")
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

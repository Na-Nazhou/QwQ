//
//  CustomerBookingLogicManager.swift
//  QwQ
//
//  Created by Nazhou Na on 19/3/20.
//

import Foundation
import os.log

class CustomerBookingLogicManager: CustomerBookingLogic {

    // Storage
    var bookingStorage: CustomerBookingStorage

    // View controller
    weak var bookingDelegate: BookingDelegate?
    weak var activitiesDelegate: ActivitiesDelegate?

    var customer: Customer

    // TODO: change to record collection
    private var currentBookRecords = RecordCollection<BookRecord>()
    var activeBookRecords: [BookRecord] {
        currentBookRecords.records
    }

    private var bookingHistory = RecordCollection<BookRecord>()
    var pastBookRecords: [BookRecord] {
        bookingHistory.records
    }

    private init(customer: Customer, bookingStorage: CustomerBookingStorage) {
        self.customer = customer
        self.bookingStorage = bookingStorage

        fetchActiveBookRecords()
        fetchBookingHistory()
    }

    deinit {
        os_log("DEINITING", log: Log.deinitLogic, type: .info)
        for record in activeBookRecords {
            bookingStorage.removeListener(for: record)
        }
    }

    func fetchActiveBookRecords() {
        bookingStorage.loadActiveBookRecords(customer: customer, completion: {
            guard let bookRecord = $0 else {
                return
            }

            self.bookingStorage.registerListener(for: bookRecord)
        })
    }

    func fetchBookingHistory() {
        bookingStorage.loadBookHistory(customer: customer, completion: {
             guard let record = $0 else {
                 return
             }
            self.didAddBookRecord(record)
         })
        
    }

    func addBookRecord(to restaurant: Restaurant, at time: Date,
                       with groupSize: Int, babyChairQuantity: Int, wheelchairFriendly: Bool) -> Bool {

        var newRecord = BookRecord(restaurant: restaurant,
                                   customer: customer,
                                   time: time,
                                   groupSize: groupSize,
                                   babyChairQuantity: babyChairQuantity,
                                   wheelchairFriendly: wheelchairFriendly)

        if !checkExistingRecords(against: newRecord) {
            return false
        }

        bookingStorage.addBookRecord(newRecord: newRecord,
                                     completion: { self.didAddBookRecord(newRecord: &newRecord, id: $0)

        })
        return true
    }

    private func didAddBookRecord(newRecord: inout BookRecord, id: String) {
        newRecord.id = id
        bookingStorage.registerListener(for: newRecord)

        bookingDelegate?.didAddRecord()
    }

    func editBookRecord(oldRecord: BookRecord,
                        at time: Date,
                        with groupSize: Int,
                        babyChairQuantity: Int,
                        wheelchairFriendly: Bool) -> Bool {
        let newRecord = BookRecord(id: oldRecord.id,
                                   restaurant: oldRecord.restaurant,
                                   customer: customer,
                                   time: time,
                                   groupSize: groupSize,
                                   babyChairQuantity: babyChairQuantity,
                                   wheelchairFriendly: wheelchairFriendly)

        if !checkExistingRecords(against: newRecord) {
            return false
        }

        bookingStorage.updateBookRecord(oldRecord: oldRecord, newRecord: newRecord, completion: {
            self.bookingDelegate?.didUpdateRecord()
        })
        return true
    }

    private func checkExistingRecords(against record: BookRecord) -> Bool {
        if activeBookRecords.contains(where: {
            $0.restaurant == record.restaurant &&
                $0.time == record.time
        }) {
            bookingDelegate?.didFindExistingRecord()
            return false
        }

        return true
    }

    func deleteBookRecord(_ record: BookRecord) {
        if record.isAdmitted {
            var newRecord = record
            newRecord.withdrawTime = Date()
            bookingStorage.updateBookRecord(oldRecord: record, newRecord: newRecord, completion: {
                self.activitiesDelegate?.didDeleteRecord()
            })
            return
        }

        bookingStorage.deleteBookRecord(record: record, completion: {
            self.activitiesDelegate?.didDeleteRecord()
        })
    }

    func didUpdateBookRecord(_ record: BookRecord) {
        os_log("Did update book record", log: Log.updateBookRecord, type: .info)
        guard let oldRecord = activeBookRecords.first(where: { $0 == record }) else {
            os_log("Detected new book record", log: Log.newBookRecord, type: .info)
            didAddBookRecord(record)
            return
        }
        let modification = record.changeType(from: oldRecord)
        switch modification {
        case .admit:
            // call some (activites) delegate to display admission status
            didAdmitBookRecord(record)
            os_log("Detected admission", log: Log.admitCustomer, type: .info)
        case .serve:
            addAsHistoryRecord(record)
            didDeleteBookRecord(record)
            os_log("Detected service", log: Log.serveCustomer, type: .info)
        case .reject:
            addAsHistoryRecord(record)
            didDeleteBookRecord(record)
            os_log("Detected rejection", log: Log.rejectCustomer, type: .info)
        case .withdraw:
            addAsHistoryRecord(record)
            didDeleteBookRecord(record)
            os_log("Detected withdrawal", log: Log.withdrawnByCustomer, type: .info)
        case .customerUpdate:
            customerDidUpdateBookRecord(record: record)
            os_log("Detected regular modification", log: Log.regularModification, type: .info)
        case .none:
            assert(false, "Modification should be something")
        }
    }

    private func customerDidUpdateBookRecord(record: BookRecord) {
        if record.isActiveRecord {
            currentBookRecords.update(record)
            activitiesDelegate?.didUpdateActiveRecords()
        }
    }

    func didAddBookRecord(_ record: BookRecord) {
        if record.isActiveRecord && currentBookRecords.add(record) {
            activitiesDelegate?.didUpdateActiveRecords()
        }

        if record.isHistoryRecord && bookingHistory.add(record) {
            activitiesDelegate?.didUpdateHistoryRecords()
        }
    }

    func didAdmitBookRecord(_ record: BookRecord) {
        guard currentBookRecords.remove(record) else {
            return
        }

        // Delete other bookings at the same time
        for otherRecord in activeBookRecords where otherRecord.time == record.time {
            bookingStorage.deleteBookRecord(record: otherRecord, completion: {})
        }

        if currentBookRecords.add(record) {
            activitiesDelegate?.didUpdateActiveRecords()
        }
    }

    func didDeleteBookRecord(_ record: BookRecord) {
        bookingStorage.removeListener(for: record)
        if currentBookRecords.remove(record) {
            activitiesDelegate?.didUpdateActiveRecords()
        }
    }

    private func addAsHistoryRecord(_ record: BookRecord) {
        if bookingHistory.add(record) {
            activitiesDelegate?.didUpdateHistoryRecords()
        }
    }
}

extension CustomerBookingLogicManager {
    private static var bookingLogic: CustomerBookingLogicManager?

    /// Returns shared customer booking logic manager for the logged in application. If it does not exist,
    /// a booking logic manager is initiailised with the given customer identity to share.
    static func shared(for customerIdentity: Customer? = nil,
                       with storage: CustomerBookingStorage? = nil) -> CustomerBookingLogicManager {
        if let logic = bookingLogic {
            return logic
        }

        assert(customerIdentity != nil,
               "Customer identity must be given non-nil to make the customer's booking logic manager.")
        assert(storage != nil,
               "Booking storage must be given non-nil")
        let logic = CustomerBookingLogicManager(customer: customerIdentity!, bookingStorage: storage!)
        logic.bookingStorage.logicDelegate = logic

        bookingLogic = logic
        return logic
    }

    static func deinitShared() {
        bookingLogic = nil
    }
}

//
//  CustomerBookingLogicManager.swift
//  QwQ
//
//  Created by Nazhou Na on 19/3/20.
//

import Foundation

class CustomerBookingLogicManager: CustomerBookingLogic {

    // Storage
    var bookingStorage: CustomerBookingStorage

    // View controller
    weak var bookingDelegate: BookingDelegate?
    weak var activitiesDelegate: ActivitiesDelegate?

    var customer: Customer

    private var currentBookRecords = Set<BookRecord>()
    var activeBookRecords: [BookRecord] {
        Array(currentBookRecords)
    }

    // TODO
    private var bookingHistory = CustomerHistory<BookRecord>()
    var pastBookRecords: [BookRecord] {
        Array(bookingHistory.history)
    }

    private init(customer: Customer, bookingStorage: CustomerBookingStorage) {
        self.customer = customer
        self.bookingStorage = bookingStorage
    }

    func fetchBookingHistory() {
        
    }

    func addBookRecord(to restaurant: Restaurant, at time: Date,
                       with groupSize: Int, babyChairQuantity: Int, wheelchairFriendly: Bool) {
        // Check conflicts
        var newRecord = BookRecord(restaurant: restaurant,
                                   customer: customer,
                                   time: time,
                                   groupSize: groupSize,
                                   babyChairQuantity: babyChairQuantity,
                                   wheelchairFriendly: wheelchairFriendly)

        bookingStorage.addBookRecord(newRecord: newRecord,
                                     completion: { self.didAddBookRecord(newRecord: &newRecord, id: $0)

        })
    }

    private func didAddBookRecord(newRecord: inout BookRecord, id: String) {
        newRecord.id = id
        currentBookRecords.insert(newRecord)

        // AddListener
        bookingDelegate?.didAddBookRecord()
    }

    func editBookRecord(oldRecord: BookRecord,
                        at time: Date,
                        with groupSize: Int,
                        babyChairQuantity: Int,
                        wheelchairFriendly: Bool) {
        // Check conflicts
        let newRecord = BookRecord(id: oldRecord.id,
                                   restaurant: oldRecord.restaurant,
                                   customer: customer,
                                   time: time,
                                   groupSize: groupSize,
                                   babyChairQuantity: babyChairQuantity,
                                   wheelchairFriendly: wheelchairFriendly)
        bookingStorage.updateBookRecord(oldRecord: oldRecord, newRecord: newRecord, completion: {
            self.bookingDelegate?.didUpdateBookRecord()
            // To remove this: (let listener handle this)
            self.customerDidUpdateBookRecord(record: newRecord)
        })
    }

    func deleteBookRecord(_ record: BookRecord) {
        bookingStorage.deleteBookRecord(record: record, completion: {
            self.activitiesDelegate?.didDeleteBookRecord()
            // To remove this: (let listener handle this)
            self.didDeleteActiveBookRecord(record)
        })
    }

    func didUpdateBookRecord(_ record: BookRecord) {
        // TODO
    }

    private func customerDidUpdateBookRecord(record: BookRecord) {
        currentBookRecords.remove(record)
        currentBookRecords.insert(record)
        activitiesDelegate?.didUpdateActiveRecords()
    }

    func didDeleteActiveBookRecord(_ record: BookRecord) {
        currentBookRecords.remove(record)
        activitiesDelegate?.didUpdateActiveRecords()
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

        bookingLogic = logic
        return logic
    }

    static func deinitShared() {
        bookingLogic = nil
    }
}

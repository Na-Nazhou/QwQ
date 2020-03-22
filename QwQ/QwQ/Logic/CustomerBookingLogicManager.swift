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
    private var bookingHistory = Set<BookRecord>()
    var pastBookRecords: [BookRecord] {
        Array(bookingHistory)
    }

    private init(customer: Customer) {
        self.customer = customer
        bookingStorage = FBBookingStorage()
    }

    func addBookRecord(to restaurant: Restaurant, at time: Date,
                       with groupSize: Int, babyChairQuantity: Int, wheelchairFriendly: Bool) {
        // Check conflicts
        var newRecord = BookRecord(restaurant: restaurant,
                                   customer: customer,
                                   groupSize: groupSize,
                                   babyChairQuantity: babyChairQuantity,
                                   wheelchairFriendly: wheelchairFriendly,
                                   time: time)

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
                                   groupSize: groupSize,
                                   babyChairQuantity: babyChairQuantity,
                                   wheelchairFriendly: wheelchairFriendly,
                                   time: time)
        bookingStorage.updateBookRecord(oldRecord: oldRecord, newRecord: newRecord, completion: {
            self.bookingDelegate?.didUpdateBookRecord()
        })
    }

    func deleteBookRecord(_ bookRecord: BookRecord) {
        bookingStorage.deleteBookRecord(record: bookRecord, completion: {
            self.activitiesDelegate?.didDeleteBookRecord()
        })
    }

    func didUpdateBookRecord(_ record: BookRecord) {
        // TODO
    }

    private func customerDidUpdateBookRecord(oldRecord: BookRecord, newRecord: inout BookRecord) {
        currentBookRecords.remove(oldRecord)
        currentBookRecords.insert(newRecord)
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
    static func shared(for customerIdentity: Customer? = nil) -> CustomerBookingLogicManager {
        if let logic = bookingLogic {
            return logic
        }

        assert(customerIdentity != nil,
               "Customer identity must be given non-nil to make the customer's booking logic manager.")
        let logic = CustomerBookingLogicManager(customer: customerIdentity!)

        bookingLogic = logic
        return logic
    }

    static func deinitShared() {
        bookingLogic = nil
    }
}

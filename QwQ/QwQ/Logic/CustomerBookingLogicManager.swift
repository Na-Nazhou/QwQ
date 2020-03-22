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

    var currentBookRecords = Set<BookRecord>()
    var activeBookRecords: [BookRecord] {
        Array(currentBookRecords)
    }

    // TODO
    var pastBookRecords: [BookRecord] {
        []
    }

    private init(customer: Customer) {
        self.customer = customer
        bookingStorage = FBBookingStorage()
    }

    func addBookRecord(to restaurant: Restaurant, at time: Date,
                       with groupSize: Int, babyChairQuantity: Int, wheelchairFriendly: Bool) {
        var newRecord = BookRecord(restaurant: restaurant,
                                   customer: customer,
                                   groupSize: groupSize,
                                   babyChairQuantity: babyChairQuantity,
                                   wheelchairFriendly: wheelchairFriendly,
                                   time: time)

        bookingStorage.addBookRecord(record: newRecord,
                                     completion: { self.didAddBookRecord(newRecord: &newRecord, id: $0)

        })
    }

    private func didAddBookRecord(newRecord: inout BookRecord, id: String) {
        newRecord.id = id
        currentBookRecords.insert(newRecord)
        bookingDelegate?.didAddBookRecord()
    }

    func editBookRecord(oldRecord: BookRecord,
                        at time: Date,
                        with groupSize: Int,
                        babyChairQuantity: Int,
                        wheelchairFriendly: Bool) {
        let newRecord = BookRecord(restaurant: oldRecord.restaurant,
                                   customer: customer,
                                   groupSize: groupSize,
                                   babyChairQuantity: babyChairQuantity,
                                   wheelchairFriendly: wheelchairFriendly,
                                   time: time)
        bookingStorage.updateBookRecord(old: oldRecord, new: newRecord, completion: {
            self.currentBookRecords.remove(oldRecord)
            self.currentBookRecords.insert(newRecord)
            self.bookingDelegate?.didUpdateBookRecord()
        })
    }

    func deleteBookRecord(_ bookRecord: BookRecord) {
        bookingStorage.deleteBookRecord(record: bookRecord, completion: {
            self.currentBookRecords.remove(bookRecord)
            self.activitiesDelegate?.didDeleteBookRecord()
        })
    }
}

extension CustomerBookingLogicManager {
    private static var bookingLogic: CustomerBookingLogicManager?

    /// Returns shared customer queue logic manager for the logged in application. If it does not exist,
    /// a queue logic manager is initiailised with the given customer identity to share.
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

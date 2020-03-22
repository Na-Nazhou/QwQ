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

    // TODO
    var currentBookRecords = [BookRecord]()

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
        currentBookRecords.append(newRecord)
        bookingDelegate?.didAddBookRecord()
    }

    func editBookRecord(at time: Date,
                        with groupSize: Int,
                        babyChairQuantity: Int,
                        wheelchairFriendly: Bool) {
        // TODO
        bookingDelegate?.didUpdateBookRecord()
    }

    func deleteBookRecord(_ bookRecord: BookRecord) {
        // TODO
        activitiesDelegate?.didDeleteBookRecord()
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

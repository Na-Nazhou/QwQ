//
//  CustomerBookingLogic.swift
//  QwQ
//
//  Created by Nazhou Na on 19/3/20.
//

import Foundation

protocol CustomerBookingLogic: BookingStorageSyncDelegate {

    // Storage
    var bookingStorage: CustomerBookingStorage { get set }

    // View Controllers
    var bookingDelegate: RecordDelegate? { get set }
    var activitiesDelegate: ActivitiesDelegate? { get set }

    func addBookRecord(to restaurant: Restaurant,
                       at time: Date,
                       with groupSize: Int,
                       babyChairQuantity: Int,
                       wheelchairFriendly: Bool)

    func editBookRecord(oldRecord: BookRecord,
                        at time: Date,
                        with groupSize: Int,
                        babyChairQuantity: Int,
                        wheelchairFriendly: Bool)

    func deleteBookRecord(_ bookRecord: BookRecord)
}

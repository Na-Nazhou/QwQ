//
//  RestaurantBookingLogicManager.swift
//  QwQ-restaurant
//
//  Created by Nazhou Na on 17/4/20.
//

import Foundation

class RestaurantBookingLogicManager: RestaurantRecordLogicManager<BookRecord>, RestaurantBookingLogic {

    // Storage
    private var bookingStorage: RestaurantBookingStorage

    // Models
    private let restaurantActivity: RestaurantActivity
    private var restaurant: Restaurant {
        restaurantActivity.restaurant
    }

    override init() {
        self.restaurantActivity = RestaurantActivity.shared()
        self.bookingStorage = FIRBookingStorage.shared

        super.init()

        self.bookingStorage.registerDelegate(self)
    }

    deinit {
        bookingStorage.unregisterDelegate(self)
    }

    func admitCustomer(record: BookRecord, completion: @escaping () -> Void) {
        let new = getUpdatedRecord(record: record, event: .admit)
        updateBookRecord(oldRecord: record, newRecord: new, completion: completion)
    }

    func serveCustomer(record: BookRecord, completion: @escaping () -> Void) {
        let new = getUpdatedRecord(record: record, event: .serve)
        updateBookRecord(oldRecord: record, newRecord: new, completion: completion)
    }

    func rejectCustomer(record: BookRecord, completion: @escaping () -> Void) {
        let new = getUpdatedRecord(record: record, event: .reject)
        updateBookRecord(oldRecord: record, newRecord: new, completion: completion)
    }

    private func updateBookRecord(oldRecord: BookRecord, newRecord: BookRecord,
                                  completion: @escaping () -> Void) {
        bookingStorage.updateRecord(oldRecord: oldRecord, newRecord: newRecord,
                                    completion: completion)
    }
}

extension RestaurantBookingLogicManager {

    // MARK: Syncing

    func didAddBookRecord(_ record: BookRecord) {
        var bookRecord = record
        if bookRecord.isPendingAdmission {
            bookRecord.autoRejectTimer = Timer(fireAt: record.time,
                                               interval: 1,
                                               target: self,
                                               selector: #selector(handleAutoRejectTimer),
                                               userInfo: bookRecord,
                                               repeats: false)
            RunLoop.main.add(bookRecord.autoRejectTimer!, forMode: .common)
        }

        didAddRecord(bookRecord,
                     restaurantActivity.currentBookings,
                     restaurantActivity.waitingBookings,
                     restaurantActivity.historyBookings)
    }

    @objc private func handleAutoRejectTimer(timer: Timer) {
        if let record = timer.userInfo as? BookRecord {
            let isStillPending = restaurantActivity.currentBookings.records.contains(record)
            if isStillPending {
                rejectCustomer(record: record, completion: {})
            }
        }
    }

    func didUpdateBookRecord(_ record: BookRecord) {
        if record.isConfirmedAdmission {
            let autoRejectTimer = Timer(
                fireAt: record.time.addingTimeInterval(60 *  Constants.timeBufferForBookArrivalInMins),
                interval: 1, target: self,
                selector: #selector(handleBufferRejectTimer),
                userInfo: record, repeats: false)
            RunLoop.main.add(autoRejectTimer, forMode: .common)
        }
        didUpdateRecord(record,
                        restaurantActivity.currentBookings,
                        restaurantActivity.waitingBookings,
                        restaurantActivity.historyBookings)
    }

    @objc private func handleBufferRejectTimer(timer: Timer) {
        if let record = timer.userInfo as? BookRecord {
            let isStillWaiting = restaurantActivity.waitingBookings.records.contains(record)
            if isStillWaiting {
                rejectCustomer(record: record, completion: {})
            }
        }
    }
}

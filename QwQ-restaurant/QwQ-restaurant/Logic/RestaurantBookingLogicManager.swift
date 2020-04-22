//
//  RestaurantBookingLogicManager.swift
//  QwQ-restaurant
//
//  Created by Nazhou Na on 17/4/20.
//

import Foundation
import os.log

class RestaurantBookingLogicManager: RestaurantRecordLogicManager<BookRecord>, RestaurantBookingLogic {

    // Storage
    private var bookingStorage: RestaurantBookingStorage

    // Models
    private let restaurantActivity: RestaurantActivity
    private var restaurant: Restaurant {
        restaurantActivity.restaurant
    }
    private var currentBookings: RecordCollection<BookRecord> {
        restaurantActivity.currentBookings
    }
    private var waitingBookings: RecordCollection<BookRecord> {
        restaurantActivity.waitingBookings
    }
    private var historyBookings: RecordCollection<BookRecord> {
        restaurantActivity.historyBookings
    }

    override init() {
        self.restaurantActivity = RestaurantActivity.shared()
        self.bookingStorage = FIRBookingStorage.shared

        super.init()

        self.bookingStorage.registerDelegate(self)
    }

    deinit {
        os_log("DEINITING booking logic manager", log: Log.deinitLogic, type: .info)
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
        scheduleAutoRejectTimer(for: record)
        didAddRecord(record, currentBookings, waitingBookings, historyBookings)
    }

    private func scheduleAutoRejectTimer(for record: BookRecord) {
        guard record.isPendingAdmission else {
            return
        }

        let autoRejectTimer = Timer(
            fireAt: record.time,
            interval: 1,
            target: self,
            selector: #selector(handleAutoRejectTimer),
            userInfo: record,
            repeats: false)
        RunLoop.main.add(autoRejectTimer, forMode: .common)
    }

    @objc private func handleAutoRejectTimer(timer: Timer) {
        if let record = timer.userInfo as? BookRecord {
            let isStillPending = currentBookings.contains(record)
            if isStillPending {
                rejectCustomer(record: record, completion: {})
            }
        }
    }

    func didUpdateBookRecord(_ record: BookRecord) {
        scheduleBufferRejectTimer(for: record)
        didUpdateRecord(record, currentBookings, waitingBookings, historyBookings)
    }

    private func scheduleBufferRejectTimer(for record: BookRecord) {
        guard record.isConfirmedAdmission else {
            return
        }

        let bufferRejectTimer = Timer(
            fireAt: record.time.addingTimeInterval(60 * Constants.timeBufferForBookArrivalInMins),
            interval: 1, target: self,
            selector: #selector(handleBufferRejectTimer),
            userInfo: record, repeats: false)
        RunLoop.main.add(bufferRejectTimer, forMode: .common)
    }

    @objc private func handleBufferRejectTimer(timer: Timer) {
        if let record = timer.userInfo as? BookRecord {
            let isStillWaiting = waitingBookings.contains(record)
            if isStillWaiting {
                rejectCustomer(record: record, completion: {})
            }
        }
    }
}

import Foundation
import os.log

/// A customer booking logic manager.
/// Customers are not allowed to book at the same restaurant for the same time.
class CustomerBookingLogicManager: CustomerRecordLogicManager<BookRecord>, CustomerBookingLogic {

    // Storage
    private var bookingStorage: CustomerBookingStorage
    
    // Notification
    private var notificationHandler: QwQNotificationHandler

    // View controller
    weak var bookingDelegate: BookingDelegate?

    // Models
    private let customerActivity: CustomerActivity
    private var customer: Customer {
        customerActivity.customer
    }
    private var currentBookings: RecordCollection<BookRecord> {
        customerActivity.currentBookings
    }
    private var bookingHistory: RecordCollection<BookRecord> {
        customerActivity.bookingHistory
    }
    private var missedBookings: RecordCollection<BookRecord> {
        RecordCollection<BookRecord>()
    }

    private var currentBookRecords: [BookRecord] {
        customerActivity.currentBookings.records
    }
    private var bookRecords: [BookRecord] {
        customerActivity.bookRecords
    }

    override convenience init() {
        self.init(customerActivity: CustomerActivity.shared(),
                  bookingStorage: FIRBookingStorage.shared,
                  notificationHandler: QwQNotificationManager.shared)
    }

    // Constructor to provide flexibility for testing.
    init(customerActivity: CustomerActivity, bookingStorage: CustomerBookingStorage,
         notificationHandler: QwQNotificationHandler) {
        self.customerActivity = customerActivity
        self.bookingStorage = bookingStorage
        self.notificationHandler = notificationHandler

        super.init()

        self.bookingStorage.registerDelegate(self)
    }

    deinit {
        os_log("Deiniting booking logic manager", log: Log.deinitLogic, type: .info)
        bookingStorage.unregisterDelegate(self)
    }

    func addBookRecords(to restaurants: [Restaurant],
                        at time: Date,
                        with groupSize: Int,
                        babyChairQuantity: Int,
                        wheelchairFriendly: Bool) -> Bool {

        var newRecords = [BookRecord]()
        for restaurant in restaurants {
            let newRecord = BookRecord(restaurant: restaurant,
                                       customer: customer,
                                       time: time,
                                       groupSize: groupSize,
                                       babyChairQuantity: babyChairQuantity,
                                       wheelchairFriendly: wheelchairFriendly)
            if !checkExistingRecords(against: newRecord) {
                bookingDelegate?.didFindExistingRecord(at: restaurant)
                return false
            }
            if !checkAdvanceBookingLimit(of: newRecord) {
                bookingDelegate?.didExceedAdvanceBookingLimit(at: restaurant)
                return false
            }
            if !checkRestaurantOperatingHours(of: newRecord) {
                bookingDelegate?.didExceedOperatingHours(at: restaurant)
                return false
            }
            newRecords.append(newRecord)
        }

        bookingStorage.addBookRecords(newRecords: newRecords) {
            self.bookingDelegate?.didAddRecords(newRecords)
        }

        return true
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

        if !checkRestaurantOperatingHours(of: newRecord) {
            bookingDelegate?.didExceedOperatingHours(at: newRecord.restaurant)
            return false
        }

        bookingStorage.updateBookRecord(oldRecord: oldRecord, newRecord: newRecord) {
            self.bookingDelegate?.didUpdateRecord()
        }

        return true
    }

    /// Returns true if there are no existing clashing records with `record`, false otherwise.
    private func checkExistingRecords(against record: BookRecord) -> Bool {
        if currentBookRecords.contains(where: {
            $0.restaurant == record.restaurant &&
                $0.time == record.time
        }) {
            return false
        }

        return true
    }

    /// Returns true if target book time of `record` is within the advance booking limit, false otherwise.
    /// Being within the limit means the customer books for a time at least advance booking limit time in advance.
    private func checkAdvanceBookingLimit(of record: BookRecord) -> Bool {
        let advanceBookingLimit = record.restaurant.advanceBookingLimit
        let currentTime = Date.getCurrentTime()
        let timeInterval = Int(record.time.timeIntervalSince(currentTime))
        return timeInterval >= advanceBookingLimit * 60 
    }

    /// Returns true if th restaurant is operating at book time of `record`.
    private func checkRestaurantOperatingHours(of record: BookRecord) -> Bool {
        guard record.restaurant.isAutoOpenCloseEnabled else {
            return true
        }

        let restaurant = record.restaurant
        let time = record.time
        let minTime = Date.getStartOfDay(of: record.time).addingTimeInterval(restaurant.autoOpenTime!)
        let maxTime = Date.getStartOfDay(of: record.time).addingTimeInterval(restaurant.autoCloseTime!)
        return time >= minTime && time <= maxTime
    }

    func withdrawBookRecord(_ record: BookRecord) {
        withdrawBookRecord(record, completion: {
            self.activitiesDelegate?.didWithdrawRecord()
        })
    }

    private func withdrawBookRecord(_ record: BookRecord, completion: @escaping () -> Void) {
        let newRecord = getUpdatedRecord(record: record, event: .withdraw)
        bookingStorage.updateBookRecord(oldRecord: record, newRecord: newRecord, completion: completion)
    }

    private func withdrawBookRecords(_ records: [BookRecord], completion: @escaping () -> Void) {
        guard !records.isEmpty else {
            completion()
            return
        }
        let newRecords = records.map {
            getUpdatedRecord(record: $0, event: .withdraw)
        }
        bookingStorage.updateBookRecords(newRecords: newRecords, completion: completion)
    }
}

extension CustomerBookingLogicManager {

    // MARK: Syncing
    /// Detects modification to `record` and updates in-app models accordingly.
    func didUpdateBookRecord(_ record: BookRecord) {
        guard let oldRecord = bookRecords.first(where: { $0 == record }) else {
            return
        }

        let modification = record.getChangeType(from: oldRecord)
        switch modification {
        case .serve:
            didServeBookRecord(record)
        case .reject:
            didRejectBookRecord(record)
        case .withdraw:
            didWithdrawBookRecord(record)
        case .customerUpdate:
            customerDidUpdateBookRecord(record)
        case .confirmAdmission:
            didConfirmAdmission(of: record)
        default:
            customerDidUpdateBookRecord(record)
        }
    }

    func didAddBookRecord(_ record: BookRecord) {
        os_log("Detected new book record", log: Log.newBookRecord, type: .info)
        super.didAddRecord(record, currentBookings, missedBookings, bookingHistory)
    }

    private func customerDidUpdateBookRecord(_ record: BookRecord) {
        super.customerDidUpdateRecord(record, currentBookings, missedBookings, bookingHistory)
    }

    private func clashingRecords(with record: BookRecord) -> [BookRecord] {
        currentBookRecords.filter {
            $0 != record && $0.time == record.time
        }
    }

    private func didConfirmAdmission(of record: BookRecord) {
        super.didConfirmRecord(record, currentBookings)

        // Auto withdraw clashing records
        withdrawBookRecords(clashingRecords(with: record), completion: {})

        notificationHandler.notifyBookingAccepted(record: record)
    }

    private func didServeBookRecord(_ record: BookRecord) {
        super.didServeRecord(record, currentBookings, bookingHistory)

    }

    private func didRejectBookRecord(_ record: BookRecord) {
        super.didRejectRecord(record, currentBookings, bookingHistory)

        notificationHandler.retractBookNotifications(for: record)
        notificationHandler.notifyBookingRejected(record: record)
    }

    private func didWithdrawBookRecord(_ record: BookRecord) {
        super.didWithdrawRecord(record, currentBookings, bookingHistory)

        notificationHandler.retractBookNotifications(for: record)
    }
}

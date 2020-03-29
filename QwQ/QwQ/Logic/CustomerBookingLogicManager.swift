import Foundation
import os.log

class CustomerBookingLogicManager: CustomerBookingLogic {
    // Storage
    var bookingStorage: CustomerBookingStorage

    // View controller
    weak var bookingDelegate: BookingDelegate?
    weak var activitiesDelegate: ActivitiesDelegate?

    private let customerActivity: CustomerActivity
    private var customer: Customer {
        customerActivity.customer
    }

    var activeBookRecords: [BookRecord] {
        customerActivity.currentBookings.records
    }
    var pastBookRecords: [BookRecord] {
        customerActivity.bookingHistory.records
    }

    convenience init() {
        self.init(customerActivity: CustomerActivity.shared(),
                  bookingStorage: FBBookingStorage.shared)
    }

    // Constructor to provide flexibility for testing.
    init(customerActivity: CustomerActivity, bookingStorage: CustomerBookingStorage) {
        self.customerActivity = customerActivity
        self.bookingStorage = bookingStorage

        self.bookingStorage.registerDelegate(self)

        fetchActiveBookRecords()
        fetchBookingHistory()
    }

    deinit {
        os_log("DEINITING booking lm", log: Log.deinitLogic, type: .info)
        bookingStorage.unregisterDelegate(self)
    }

    func fetchActiveBookRecords() {
        if !activeBookRecords.isEmpty {
            os_log("Active book records already loaded.", log: Log.loadActivity, type: .info)
            return //already loaded, no need to reload.
        }
        bookingStorage.loadActiveBookRecords(customer: customer, completion: {
            guard let bookRecord = $0 else {
                return
            }

            self.didAddBookRecord(bookRecord)
        })
    }

    func fetchBookingHistory() {
        if !pastBookRecords.isEmpty {
            os_log("History book records already loaded.", log: Log.loadActivity, type: .info)
            return
        }
        bookingStorage.loadBookHistory(customer: customer, completion: {
             guard let record = $0 else {
                 return
             }

            self.didAddBookRecord(record)
         })
    }

    func addBookRecord(to restaurant: Restaurant, at time: Date,
                       with groupSize: Int, babyChairQuantity: Int, wheelchairFriendly: Bool) -> Bool {

        let newRecord = BookRecord(restaurant: restaurant,
                                   customer: customer,
                                   time: time,
                                   groupSize: groupSize,
                                   babyChairQuantity: babyChairQuantity,
                                   wheelchairFriendly: wheelchairFriendly)

        if !checkExistingRecords(against: newRecord) {
            return false
        }

        bookingStorage.addBookRecord(newRecord: newRecord)
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

        if !checkExistingRecords(against: newRecord) {
            return false
        }

        bookingStorage.updateBookRecord(oldRecord: oldRecord, newRecord: newRecord)
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

    func withdrawBookRecord(_ record: BookRecord) {
        var newRecord = record
        newRecord.withdrawTime = Date()
        bookingStorage.updateBookRecord(oldRecord: record, newRecord: newRecord)
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
            didAdmitBookRecord(record)
            os_log("Detected admission", log: Log.admitCustomer, type: .info)
        case .serve:
            addAsHistoryRecord(record)
            removeFromCurrent(record)
            os_log("Detected service", log: Log.serveCustomer, type: .info)
        case .reject:
            addAsHistoryRecord(record)
            removeFromCurrent(record)
            os_log("Detected rejection", log: Log.rejectCustomer, type: .info)
        case .withdraw:
            addAsHistoryRecord(record)
            removeFromCurrent(record)
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
            customerActivity.currentBookings.update(record)
            activitiesDelegate?.didUpdateActiveRecords()
            bookingDelegate?.didUpdateRecord()
        }
    }

    private func didAddBookRecord(_ record: BookRecord) {
        if record.isActiveRecord && customerActivity.currentBookings.add(record) {
            activitiesDelegate?.didUpdateActiveRecords()
        }

        if record.isHistoryRecord && customerActivity.bookingHistory.add(record) {
            activitiesDelegate?.didUpdateHistoryRecords()
        }
    }

    private func didAdmitBookRecord(_ record: BookRecord) {
        guard customerActivity.currentBookings.remove(record) else {
            return
        }

        // Delete other bookings at the same time
        for otherRecord in activeBookRecords where otherRecord.time == record.time {
            withdrawBookRecord(otherRecord)
        }

        if customerActivity.currentBookings.add(record) {
            activitiesDelegate?.didUpdateActiveRecords()
        }
    }

    private func removeFromCurrent(_ record: BookRecord) {
        if customerActivity.currentBookings.remove(record) {
            activitiesDelegate?.didUpdateActiveRecords()
        }
    }

    private func addAsHistoryRecord(_ record: BookRecord) {
        if customerActivity.bookingHistory.add(record) {
            activitiesDelegate?.didUpdateHistoryRecords()
        }
    }
}

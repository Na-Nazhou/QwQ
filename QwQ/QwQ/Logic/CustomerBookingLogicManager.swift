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
    var bookRecords: [BookRecord] {
        customerActivity.bookRecords
    }

    convenience init() {
        self.init(customerActivity: CustomerActivity.shared(),
                  bookingStorage: FIRBookingStorage.shared)
    }

    // Constructor to provide flexibility for testing.
    init(customerActivity: CustomerActivity, bookingStorage: CustomerBookingStorage) {
        self.customerActivity = customerActivity
        self.bookingStorage = bookingStorage

        self.bookingStorage.registerDelegate(self)
    }

    deinit {
        os_log("DEINITING booking lm", log: Log.deinitLogic, type: .info)
        bookingStorage.unregisterDelegate(self)
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

        bookingStorage.addBookRecord(newRecord: newRecord) {
            self.bookingDelegate?.didAddRecord()
        }
        return true
    }

    func editBookRecord(oldRecord: BookRecord,
                        at time: Date,
                        with groupSize: Int,
                        babyChairQuantity: Int,
                        wheelchairFriendly: Bool) {
        let newRecord = BookRecord(id: oldRecord.id,
                                   restaurant: oldRecord.restaurant,
                                   customer: customer,
                                   time: time,
                                   groupSize: groupSize,
                                   babyChairQuantity: babyChairQuantity,
                                   wheelchairFriendly: wheelchairFriendly)

        bookingStorage.updateBookRecord(oldRecord: oldRecord, newRecord: newRecord) {
            self.bookingDelegate?.didUpdateRecord()
        }
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
        withdrawBookRecord(record, completion: {
            self.activitiesDelegate?.didWithdrawRecord()
        })
    }

    private func withdrawBookRecord(_ record: BookRecord, completion: @escaping () -> Void) {
        var newRecord = record
        newRecord.withdrawTime = Date()
        bookingStorage.updateBookRecord(oldRecord: record, newRecord: newRecord) {
            completion()
        }
    }

    func confirmAdmissionOfBookRecord(_ record: BookRecord) {
        //TODO
    }

    func didUpdateBookRecord(_ record: BookRecord) {
        guard let oldRecord = bookRecords.first(where: { $0 == record }) else {
            return
        }

        let modification = record.changeType(from: oldRecord)
        switch modification {
        case .admit:
            didAdmitBookRecord(record)
        case .serve:
            didServeBookRecord(record)
        case .reject:
            didRejectBookRecord(record)
        case .withdraw:
            didWithdrawBookRecord(record)
        case .customerUpdate:
            customerDidUpdateBookRecord(record: record)
        default:
            assert(false, "Modification should be something")
        }
    }

    private func customerDidUpdateBookRecord(record: BookRecord) {
        print("Customer updated the book record??")
        if record.isActiveRecord && customerActivity.currentBookings.update(record) {
            os_log("Detected regular modification", log: Log.regularModification, type: .info)
            activitiesDelegate?.didUpdateActiveRecords()
        }
    }

    func didAddBookRecord(_ record: BookRecord) {
        os_log("Detected new book record", log: Log.newBookRecord, type: .info)
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
            withdrawBookRecord(otherRecord, completion: {})
        }

        if customerActivity.currentBookings.add(record) {
            activitiesDelegate?.didUpdateActiveRecords()
        }

        os_log("Detected admission", log: Log.admitCustomer, type: .info)
    }

    private func didServeBookRecord(_ record: BookRecord) {
        addAsHistoryRecord(record)
        removeFromCurrent(record)
        os_log("Detected service", log: Log.serveCustomer, type: .info)
    }

    private func didRejectBookRecord(_ record: BookRecord) {
        addAsHistoryRecord(record)
        removeFromCurrent(record)
        os_log("Detected rejection", log: Log.rejectCustomer, type: .info)
    }

    private func didWithdrawBookRecord(_ record: BookRecord) {
        addAsHistoryRecord(record)
        removeFromCurrent(record)
        os_log("Detected withdrawal", log: Log.withdrawnByCustomer, type: .info)
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

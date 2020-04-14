import Foundation
import os.log

class CustomerBookingLogicManager: CustomerBookingLogic {

    // Storage
    private var bookingStorage: CustomerBookingStorage

    // View controller
    weak var bookingDelegate: BookingDelegate?
    weak var activitiesDelegate: ActivitiesDelegate?

    // Models
    private let customerActivity: CustomerActivity
    private var customer: Customer {
        customerActivity.customer
    }

    private var activeBookRecords: [BookRecord] {
        customerActivity.currentBookings.records
    }
    private var bookRecords: [BookRecord] {
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
        os_log("DEINITING booking logic manager", log: Log.deinitLogic, type: .info)
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
            bookingDelegate?.didFindExistingRecord(at: restaurant)
            return false
        }

        bookingStorage.addBookRecord(newRecord: newRecord) {
            self.bookingDelegate?.didAddRecord()
        }
        return true
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

    private func withdrawBookRecords(_ records: [BookRecord], completion: @escaping () -> Void) {
        guard !records.isEmpty else {
            completion()
            return
        }
        let withdrawTime = Date()
        var newRecords = [BookRecord]()
        for record in records {
            var newRecord = record
            newRecord.withdrawTime = withdrawTime
            newRecords.append(newRecord)
        }
        bookingStorage.updateBookRecords(newRecords: newRecords, completion: completion)
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
        case .confirmAdmission:
            didConfirmAdmission(of: record)
        default:
            assert(false, "Modification should be something")
        }
    }

    private func customerDidUpdateBookRecord(record: BookRecord) {
        os_log("Detected regular modification", log: Log.regularModification, type: .info)
        if customerActivity.currentBookings.update(record) {
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

    private func clashingRecords(with record: BookRecord) -> [BookRecord] {
        activeBookRecords.filter {
            $0 != record && $0.time == record.time
        }
    }

    private func didAdmitBookRecord(_ record: BookRecord) {
        os_log("Detected admission", log: Log.admitCustomer, type: .info)
        guard customerActivity.currentBookings.update(record) else {
            return
        }
        activitiesDelegate?.didUpdateActiveRecords()
    }

    private func didConfirmAdmission(of record: BookRecord) {
        os_log("Detected confirmation", log: Log.confirmedByCustomer, type: .info)
        guard customerActivity.currentBookings.update(record) else {
            return
        }

        withdrawBookRecords(clashingRecords(with: record), completion: {})
        activitiesDelegate?.didUpdateActiveRecords()
        QwQNotificationManager().notifyBookingAcceptance(record: record)
    }

    private func didServeBookRecord(_ record: BookRecord) {
        os_log("Detected service", log: Log.serveCustomer, type: .info)
        addAsHistoryRecord(record)
        removeFromCurrent(record)

    }

    private func didRejectBookRecord(_ record: BookRecord) {
        os_log("Detected rejection", log: Log.rejectCustomer, type: .info)
        addAsHistoryRecord(record)
        removeFromCurrent(record)
    }

    private func didWithdrawBookRecord(_ record: BookRecord) {
        os_log("Detected withdrawal", log: Log.withdrawnByCustomer, type: .info)
        addAsHistoryRecord(record)
        removeFromCurrent(record)
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

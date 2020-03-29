import Foundation

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
        for record in activeBookRecords {
            bookingStorage.removeListener(for: record)
        }
        bookingStorage.unregisterDelegate(self)
    }

    func fetchActiveBookRecords() {
        bookingStorage.loadActiveBookRecords(customer: customer, completion: {
            guard let bookRecord = $0 else {
                return
            }

            self.bookingStorage.registerListener(for: bookRecord)
        })
    }

    func fetchBookingHistory() {
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

        bookingStorage.addBookRecord(newRecord: newRecord,
                                     completion: { self.didAddBookRecord(newRecord: newRecord, withUpdatedId: $0)

        })
        return true
    }

    private func didAddBookRecord(newRecord: BookRecord, withUpdatedId id: String) {
        var updatedIdRec = newRecord
        updatedIdRec.id = id
        guard customerActivity.currentBookings.add(updatedIdRec) else {
            return
        }
        bookingStorage.registerListener(for: newRecord)

        bookingDelegate?.didAddRecord()
        activitiesDelegate?.didUpdateActiveRecords()
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

        bookingStorage.updateBookRecord(oldRecord: oldRecord, newRecord: newRecord, completion: {
            self.bookingDelegate?.didUpdateRecord()
            self.activitiesDelegate?.didUpdateActiveRecords()
        })
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

    func deleteBookRecord(_ record: BookRecord) {
        if record.isAdmitted {
            var newRecord = record
            newRecord.withdrawTime = Date()
            bookingStorage.updateBookRecord(oldRecord: record, newRecord: newRecord, completion: {
                self.activitiesDelegate?.didDeleteRecord()
            })
            return
        }

        bookingStorage.deleteBookRecord(record: record, completion: {
            self.activitiesDelegate?.didDeleteRecord()
        })
    }

    func didUpdateBookRecord(_ record: BookRecord) {
        print("\nDid update book record\n")
        guard let oldRecord = activeBookRecords.first(where: { $0 == record }) else {
            print("\ndetected new\n")
            didAddBookRecord(record)
            return
        }
        let modification = record.changeType(from: oldRecord)
        switch modification {
        case .admit:
            // call some (activites) delegate to display admission status
            didAdmitBookRecord(record)
            print("\ndetected admission\n")
        case .serve:
            addAsHistoryRecord(record)
            didDeleteBookRecord(record)
            print("\ndetected service\n")
        case .reject:
            addAsHistoryRecord(record)
            didDeleteBookRecord(record)
            print("\ndetected rejection\n")
        case .withdraw:
            addAsHistoryRecord(record)
            didDeleteBookRecord(record)
        case .customerUpdate:
            customerDidUpdateBookRecord(record: record)
            print("\ndetected regular modif\n")
        case .none:
            assert(false, "Modification should be something")
        }
    }

    private func customerDidUpdateBookRecord(record: BookRecord) {
        if record.isActiveRecord {
            customerActivity.currentBookings.update(record)
            activitiesDelegate?.didUpdateActiveRecords()
        }
    }

    func didAddBookRecord(_ record: BookRecord) {
        if record.isActiveRecord && customerActivity.currentBookings.add(record) {
            activitiesDelegate?.didUpdateActiveRecords()
        }

        if record.isHistoryRecord && customerActivity.bookingHistory.add(record) {
            activitiesDelegate?.didUpdateHistoryRecords()
        }
    }

    func didAdmitBookRecord(_ record: BookRecord) {
        guard customerActivity.currentBookings.remove(record) else {
            return
        }

        // Delete other bookings at the same time
        for otherRecord in activeBookRecords where otherRecord.time == record.time {
            bookingStorage.deleteBookRecord(record: otherRecord, completion: {})
        }

        if customerActivity.currentBookings.add(record) {
            activitiesDelegate?.didUpdateActiveRecords()
        }
    }

    func didDeleteBookRecord(_ record: BookRecord) {
        removeFromCurrent(record)
    }

    private func removeFromCurrent(_ record: BookRecord) {
        bookingStorage.removeListener(for: record)
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

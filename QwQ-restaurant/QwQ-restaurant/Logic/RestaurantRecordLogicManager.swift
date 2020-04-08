import Foundation
class RestaurantRecordLogicManager: RestaurantRecordLogic {

    // Storage
    private(set) var queueStorage: RestaurantQueueStorage
    private(set) var bookingStorage: RestaurantBookingStorage

    // View Controller
    weak var presentationDelegate: RestaurantQueueLogicPresentationDelegate?

    convenience init() {
        self.init(restaurantActivity: RestaurantActivity.shared(),
                  queueStorage: FIRQueueStorage.shared,
                  bookingStorage: FIRBookingStorage.shared)
    }

    init(restaurantActivity: RestaurantActivity,
         queueStorage: RestaurantQueueStorage,
         bookingStorage: RestaurantBookingStorage) {
        self.restaurantActivity = restaurantActivity

        self.queueStorage = queueStorage
        self.bookingStorage = bookingStorage

        self.queueStorage.registerDelegate(self)
        self.bookingStorage.registerDelegate(self)
    }

    deinit {
        queueStorage.unregisterDelegate(self)
        bookingStorage.unregisterDelegate(self)
    }

    private let restaurantActivity: RestaurantActivity
    private var restaurant: Restaurant {
        restaurantActivity.restaurant
    }

    var currentRecords: [Record] {
        let bookRecords = restaurantActivity.currentQueue.records
        let queueRecords = restaurantActivity.currentBookings.records
        return (bookRecords + queueRecords).sorted(by: { record1, record2 in
            let time1: Date
            let time2: Date
            if let queueRecord1 = record1 as? QueueRecord {
                time1 = queueRecord1.startTime
            } else {
                time1 = (record1 as? BookRecord)!.time
            }
            if let queueRecord2 = record2 as? QueueRecord {
                time2 = queueRecord2.startTime
            } else {
                time2 = (record2 as? BookRecord)!.time
            }
            return time1 > time2
        })
    }

    var waitingRecords: [Record] {
        let bookRecords = restaurantActivity.waitingQueue.records
        let queueRecords = restaurantActivity.waitingBookings.records
        return (bookRecords + queueRecords).sorted(by: { record1, record2 in
            record1.admitTime! > record2.admitTime!
        })
    }

    var historyRecords: [Record] {
        let bookRecords = restaurantActivity.historyQueue.records
        let queueRecords = restaurantActivity.historyBookings.records
        return (bookRecords + queueRecords).sorted(by: { record1, record2 in
            let time1: Date
            let time2: Date
            if record1.isServed {
                time1 = record1.serveTime!
            } else if record1.isRejected {
                time1 = record1.rejectTime!
            } else {
                time1 = record1.withdrawTime!
            }
            if record2.isServed {
                time2 = record2.serveTime!
            } else if record2.isRejected {
                time2 = record2.rejectTime!
            } else {
                time2 = record2.withdrawTime!
            }
            return time1 > time2
        })
    }
    
    var isQueueOpen: Bool {
        restaurant.isQueueOpen
    }

    var isValidRestaurant: Bool {
        restaurant.isValidRestaurant
    }

    func openQueue() {
        let time = currentTime()
        var new = restaurant
        new.queueOpenTime = time

        queueStorage.updateRestaurantQueueStatus(old: restaurant, new: new)
    }

    func closeQueue() {
        let time = currentTime()
        var new = restaurant
        new.queueCloseTime = time

        queueStorage.updateRestaurantQueueStatus(old: restaurant, new: new)
    }

    func notifyCustomerOfAdmission(record: QueueRecord) {
        //setup timer events
    }

    func notifyCustomerOfRejection(record: QueueRecord) {
        // send one time message to tell customer it has taken them __ min but
        // hasnt arrived so they kicked them out or sth
    }

    func alertRestaurantIfCustomerTookTooLongToArrive(record: QueueRecord) {
        // TODO: popup alert
    }

    // MARK: - sync from global db update
    func restaurantDidPossiblyChangeQueueStatus(restaurant: Restaurant) {
        if self.restaurant.isQueueOpen != restaurant.isQueueOpen {
            presentationDelegate?.restaurantDidChangeQueueStatus(toIsOpen: restaurant.isQueueOpen)
        }
        self.restaurantActivity.updateRestaurant(restaurant)
    }
}

extension RestaurantRecordLogicManager {
    func didAddRecord<T: Record>(_ record: T,
                                 currentList: RecordCollection<T>,
                                 waitingList: RecordCollection<T>,
                                 historyList: RecordCollection<T>) {
        if record.isPendingAdmission {
            if addRecord(record, to: currentList) {
                self.presentationDelegate?.didUpdateCurrentList()
            }
        }

        if record.isAdmitted || record.isConfirmedAdmission {
            if addRecord(record, to: waitingList) {
                self.presentationDelegate?.didUpdateWaitingList()
            }
        }

        if record.isHistoryRecord {
            if addRecord(record, to: historyList) {
                self.presentationDelegate?.didUpdateHistoryList()
            }
        }
    }

    func addRecord<T: Record>(_ record: T, to list: RecordCollection<T>) -> Bool {
        list.add(record)
    }

    func didUpdateRecord<T: Record>(_ record: T,
                                    currentList: RecordCollection<T>,
                                    waitingList: RecordCollection<T>,
                                    historyList: RecordCollection<T>) {
        if record.isPendingAdmission {
            currentList.update(record)
            self.presentationDelegate?.didUpdateCurrentList()
        }

        if record.isAdmitted {
            if currentList.remove(record) {
                self.presentationDelegate?.didUpdateCurrentList()
            }
            if waitingList.add(record) {
                self.presentationDelegate?.didUpdateWaitingList()
            }
        }

        if record.isConfirmedAdmission {
            if currentList.remove(record) {
                self.presentationDelegate?.didUpdateCurrentList()
            }
            if waitingList.add(record) {
                self.presentationDelegate?.didUpdateWaitingList()
            }
            if waitingList.update(record) {
                self.presentationDelegate?.didUpdateWaitingList()
            }
        }

        if record.isHistoryRecord {
            if currentList.remove(record) {
                self.presentationDelegate?.didUpdateCurrentList()
            }

            if waitingList.remove(record) {
                self.presentationDelegate?.didUpdateWaitingList()
            }

            if historyList.add(record) {
                self.presentationDelegate?.didUpdateHistoryList()
            }
        }
    }

    func didAddQueueRecord(_ record: QueueRecord) {
        didAddRecord(record,
                     currentList: restaurantActivity.currentQueue,
                     waitingList: restaurantActivity.waitingQueue,
                     historyList: restaurantActivity.historyQueue)
    }

    func didUpdateQueueRecord(_ record: QueueRecord) {
        didUpdateRecord(record,
                        currentList: restaurantActivity.currentQueue,
                        waitingList: restaurantActivity.waitingQueue,
                        historyList: restaurantActivity.historyQueue)
    }

    func didAddBookRecord(_ record: BookRecord) {
        didAddRecord(record,
                     currentList: restaurantActivity.currentBookings,
                     waitingList: restaurantActivity.waitingBookings,
                     historyList: restaurantActivity.historyBookings)
    }

    func didUpdateBookRecord(_ record: BookRecord) {
        didUpdateRecord(record,
                        currentList: restaurantActivity.currentBookings,
                        waitingList: restaurantActivity.waitingBookings,
                        historyList: restaurantActivity.historyBookings)
    }

    func admitCustomer(record: QueueRecord, completion: @escaping () -> Void) {
        let new = getUpdatedRecord(record: record, event: .admit)
        updateQueueRecord(oldRecord: record, newRecord: new, completion: completion)
    }

    func serveCustomer(record: QueueRecord, completion: @escaping () -> Void) {
        let new = getUpdatedRecord(record: record, event: .serve)
        updateQueueRecord(oldRecord: record, newRecord: new, completion: completion)
    }

    func rejectCustomer(record: QueueRecord, completion: @escaping () -> Void) {
        let new = getUpdatedRecord(record: record, event: .reject)
        updateQueueRecord(oldRecord: record, newRecord: new, completion: completion)
    }

    private func updateQueueRecord(oldRecord: QueueRecord, newRecord: QueueRecord,
                                   completion: @escaping () -> Void) {
        queueStorage.updateRecord(oldRecord: oldRecord, newRecord: newRecord,
                                  completion: completion)
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

    func getUpdatedRecord<T: Record>(record: T, event: RecordModification) -> T {
        var new = record
        let time = currentTime()
        switch event {
        case .admit:
            new.admitTime = time
        case .serve:
            new.serveTime = time
        case .reject:
            new.rejectTime = time
        default:
            assert(false)
        }
        return new
    }
}

extension RestaurantRecordLogicManager {
    private func currentTime() -> Date {
        Date()
    }
}

import Foundation
class RestaurantRecordLogicManager: RestaurantRecordLogic {

    // Storage
    private(set) var queueStorage: RestaurantQueueStorage
    private(set) var bookingStorage: RestaurantBookingStorage

    // View Controller
    weak var presentationDelegate: RestaurantQueueLogicPresentationDelegate?

    private convenience init(restaurant: Restaurant) {
        self.init(restaurant: restaurant, queueStorage: FBQueueStorage.shared, bookingStorage: FBBookingStorage.shared)
    }

    private init(restaurant: Restaurant,
                 queueStorage: RestaurantQueueStorage,
                 bookingStorage: RestaurantBookingStorage) {
        self.restaurant = restaurant

        self.queueStorage = queueStorage
        self.bookingStorage = bookingStorage

        self.queueStorage.registerDelegate(self)
        self.bookingStorage.registerDelegate(self)
    }

    deinit {
        queueStorage.unregisterDelegate(self)
        bookingStorage.unregisterDelegate(self)
    }

    private var restaurant: Restaurant
    private(set) var currentQueue = RecordCollection<QueueRecord>()
    private(set) var waitingQueue = RecordCollection<QueueRecord>()
    private(set) var historyQueue = RecordCollection<QueueRecord>()
    private(set) var currentBookings = RecordCollection<BookRecord>()
    private(set) var waitingBookings = RecordCollection<BookRecord>()
    private(set) var historyBookings = RecordCollection<BookRecord>()

    var currentRecords: [Record] {
        (currentQueue.records + currentBookings.records).sorted(by: { record1, record2 in
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
        (waitingQueue.records + waitingBookings.records).sorted(by: { record1, record2 in
            record1.admitTime! > record2.admitTime!
        })
    }

    var historyRecords: [Record] {
        (historyQueue.records + historyBookings.records).sorted(by: { record1, record2 in
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
        self.restaurant = restaurant
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

        if record.isAdmitted {
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
            currentList.update(to: record)
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

        if record.isHistoryRecord {
            if waitingList.remove(record) {
                self.presentationDelegate?.didUpdateWaitingList()
            }

            if historyList.add(record) {
                self.presentationDelegate?.didUpdateHistoryList()
            }
        }
    }

    func didDeleteRecord<T: Record>(_ record: T,
                                    currentList: RecordCollection<T>,
                                    waitingList: RecordCollection<T>,
                                    historyList: RecordCollection<T>) {
        if record.isPendingAdmission {
            if currentList.remove(record) {
                self.presentationDelegate?.didUpdateCurrentList()
            }
        }
    }

    func didAddQueueRecord(_ record: QueueRecord) {
        didAddRecord(record, currentList: currentQueue,
                     waitingList: waitingQueue, historyList: historyQueue)
    }

    func didUpdateQueueRecord(_ record: QueueRecord) {
        didUpdateRecord(record, currentList: currentQueue,
                        waitingList: waitingQueue, historyList: historyQueue)
    }

    func didDeleteQueueRecord(_ record: QueueRecord) {
        didDeleteRecord(record, currentList: currentQueue,
                        waitingList: waitingQueue, historyList: historyQueue)
    }

    func didAddBookRecord(_ record: BookRecord) {
        didAddRecord(record, currentList: currentBookings,
                     waitingList: waitingBookings, historyList: historyBookings)
    }

    func didUpdateBookRecord(_ record: BookRecord) {
        didUpdateRecord(record, currentList: currentBookings,
                        waitingList: waitingBookings, historyList: historyBookings)
    }

    func didDeleteBookRecord(_ record: BookRecord) {
        didDeleteRecord(record, currentList: currentBookings,
                        waitingList: waitingBookings, historyList: historyBookings)
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

    func updateQueueRecord(oldRecord: QueueRecord, newRecord: QueueRecord,
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

    func updateBookRecord(oldRecord: BookRecord, newRecord: BookRecord,
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
    // Singleton created upon successful login
    private static var queueLogic: RestaurantRecordLogicManager?

    /// Returns shared restaurant queue logic manager for the logged in application. If it does not exist,
    /// a queue logic manager is initiailised with the given restaurant identity to share.
    static func shared(for restaurantIdentity: Restaurant? = nil) -> RestaurantRecordLogicManager {
        if let logic = queueLogic {
            return logic
        }

        assert(restaurantIdentity != nil,
               "Restaurant identity must be given non-nil to make the restaurant's queue logic manager.")
        let logic = RestaurantRecordLogicManager(restaurant: restaurantIdentity!)
        queueLogic = logic
        return logic
    }

    static func deinitShared() {
        queueLogic = nil
    }
}

extension RestaurantRecordLogicManager {
    private func currentTime() -> Date {
        Date()
    }
}

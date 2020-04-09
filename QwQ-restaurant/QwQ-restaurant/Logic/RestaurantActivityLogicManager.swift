import Foundation

class RestaurantActivityLogicManager: RestaurantActivityLogic {

    // Storage
    private var queueStorage: RestaurantQueueStorage
    private var bookingStorage: RestaurantBookingStorage

    // View Controller
    weak var activitiesDelegate: ActivitiesDelegate?

    private let restaurantActivity: RestaurantActivity

    private var restaurant: Restaurant {
        restaurantActivity.restaurant
    }

    var currentRecords: [Record] {
        restaurantActivity.currentRecords
    }

    var waitingRecords: [Record] {
        restaurantActivity.waitingRecords
    }

    var historyRecords: [Record] {
        restaurantActivity.historyRecords
    }
    
    var isQueueOpen: Bool {
        restaurant.isQueueOpen
    }

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
            activitiesDelegate?.restaurantDidChangeQueueStatus(toIsOpen: restaurant.isQueueOpen)
        }
        self.restaurantActivity.updateRestaurant(restaurant)
    }
}

extension RestaurantActivityLogicManager {
    func didAddRecord<T: Record>(_ record: T,
                                 currentList: RecordCollection<T>,
                                 waitingList: RecordCollection<T>,
                                 historyList: RecordCollection<T>) {
        if record.isPendingAdmission {
            if addRecord(record, to: currentList) {
                self.activitiesDelegate?.didUpdateCurrentList()
            }
        }

        if record.isAdmitted || record.isConfirmedAdmission {
            if addRecord(record, to: waitingList) {
                self.activitiesDelegate?.didUpdateWaitingList()
            }
        }

        if record.isHistoryRecord {
            if addRecord(record, to: historyList) {
                self.activitiesDelegate?.didUpdateHistoryList()
            }
        }
    }

    func addRecord<T: Record>(_ record: T, to collection: RecordCollection<T>) -> Bool {
        collection.add(record)
    }

    func didUpdateRecord<T: Record>(_ record: T,
                                    currentList: RecordCollection<T>,
                                    waitingList: RecordCollection<T>,
                                    historyList: RecordCollection<T>) {
        if record.isPendingAdmission {
            currentList.update(record)
            self.activitiesDelegate?.didUpdateCurrentList()
        }

        if record.isAdmitted {
            if currentList.remove(record) {
                self.activitiesDelegate?.didUpdateCurrentList()
            }
            if waitingList.add(record) {
                self.activitiesDelegate?.didUpdateWaitingList()
            }
        }

        if record.isConfirmedAdmission {
            if currentList.remove(record) {
                self.activitiesDelegate?.didUpdateCurrentList()
            }
            if waitingList.add(record) {
                self.activitiesDelegate?.didUpdateWaitingList()
            }
            if waitingList.update(record) {
                self.activitiesDelegate?.didUpdateWaitingList()
            }
        }

        if record.isHistoryRecord {
            if currentList.remove(record) {
                self.activitiesDelegate?.didUpdateCurrentList()
            }

            if waitingList.remove(record) {
                self.activitiesDelegate?.didUpdateWaitingList()
            }

            if historyList.add(record) {
                self.activitiesDelegate?.didUpdateHistoryList()
            }
        }
    }

    private func getQueueInFront(of newRecord: QueueRecord) -> Int {
        var count = 0
        for record in currentRecords {
            if let queueRecord = record as? QueueRecord {
                if queueRecord.startTime < newRecord.startTime {
                    count += 1
                }
            }
            if let bookRecord = record as? BookRecord {
                if bookRecord.time < newRecord.startTime {
                    count += 1
                }
            }
        }
        return count
    }

    func didAddQueueRecord(_ record: QueueRecord) {
        // Set estimated admit time
        // TODO: Assume average waiting time per customer is 10 minutes (replace with stats later)
        var newRecord = record
        if record.isPendingAdmission {
            let queueSize = getQueueInFront(of: record)

            if queueSize == 0 {
                newRecord.estimatedAdmitTime = Calendar.current.date(byAdding: .minute, value: 5, to: Date())!
            } else {
                if let queueRecord = currentRecords[0] as? QueueRecord,
                    let reference = queueRecord.estimatedAdmitTime {
                    newRecord.estimatedAdmitTime = Calendar.current.date(byAdding: .minute,
                                                                         value: queueSize * 10,
                                                                         to: reference)!
                }
                if let bookRecord = currentRecords[0] as? BookRecord {
                    newRecord.estimatedAdmitTime = Calendar.current.date(byAdding: .minute,
                                                                         value: queueSize * 10,
                                                                         to: bookRecord.time)!
                }
            }
            updateQueueRecord(oldRecord: record, newRecord: newRecord, completion: {})
        }

        didAddRecord(newRecord,
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
        // Update estimated admit time
        // TODO
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

extension RestaurantActivityLogicManager {
    private func currentTime() -> Date {
        Date()
    }
}

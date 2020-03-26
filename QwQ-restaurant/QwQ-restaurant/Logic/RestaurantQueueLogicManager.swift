import Foundation
class RestaurantQueueLogicManager: RestaurantQueueLogic {

    // Storage
    private(set) var queueStorage: RestaurantQueueStorage
    private(set) var bookingStorage: RestaurantBookingStorage

    // View Controller
    weak var presentationDelegate: RestaurantQueueLogicPresentationDelegate?

    private init(restaurant: Restaurant) {
        self.restaurant = restaurant

        queueStorage = FBQueueStorage(restaurant: restaurant)
        bookingStorage = FBBookingStorage(restaurant: restaurant)
    }

    private var restaurant: Restaurant
    private(set) var currentQueue = RecordCollection<QueueRecord>()
    private(set) var waitingQueue = RecordCollection<QueueRecord>()
    private(set) var historyQueue = RecordCollection<QueueRecord>()
    private(set) var currentBookings = RecordCollection<BookRecord>()
    private(set) var waitingBookings = RecordCollection<BookRecord>()
    private(set) var historyBookings = RecordCollection<BookRecord>()

    var currentRecords: [Record] {
        currentQueue.records + currentBookings.records
    }

    var waitingRecords: [Record] {
        waitingQueue.records + waitingBookings.records
    }

    var historyRecords: [Record] {
        historyQueue.records + historyBookings.records
    }
    
    var isQueueOpen: Bool {
        restaurant.isQueueOpen
    }

    func didAddQueueRecord(_ record: QueueRecord) {
        if record.isPendingAdmission {
            if addRecord(record, to: currentQueue) {
                self.presentationDelegate?.didUpdateCurrentList()
            }
        }

        if record.isAdmitted {
            if addRecord(record, to: waitingQueue) {
                self.presentationDelegate?.didUpdateWaitingList()
            }
        }

        if record.isHistoryRecord {
            if addRecord(record, to: historyQueue) {
                self.presentationDelegate?.didUpdateHistoryList()
            }
        }
    }

    func addRecord<T: Record>(_ record: T, to list: RecordCollection<T>) -> Bool {
        list.add(record)
    }

    func didUpdateQueueRecord(_ record: QueueRecord) {
        if record.isPendingAdmission {
            currentQueue.update(to: record)
            self.presentationDelegate?.didUpdateCurrentList()
        }

        if record.isAdmitted {
            if self.currentQueue.remove(record) {
                self.presentationDelegate?.didUpdateCurrentList()
            }
            if self.waitingQueue.add(record) {
                self.presentationDelegate?.didUpdateWaitingList()
            }
        }

        if record.isHistoryRecord {
            if self.waitingQueue.remove(record) {
                self.presentationDelegate?.didUpdateWaitingList()
            }

            if self.historyQueue.add(record) {
                self.presentationDelegate?.didUpdateHistoryList()
            }
        }
    }

    func didDeleteQueueRecord(_ record: QueueRecord) {
        if record.isPendingAdmission {
            if self.currentQueue.remove(record) {
                self.presentationDelegate?.didUpdateCurrentList()
            }
        }

        if record.isAdmitted {
            if self.waitingQueue.remove(record) {
                self.presentationDelegate?.didUpdateWaitingList()
            }
        }
    }

    func didAddBookRecord(_ record: BookRecord) {
        if record.isPendingAdmission {
            if addRecord(record, to: currentBookings) {
                self.presentationDelegate?.didUpdateCurrentList()
            }
        }

        if record.isAdmitted {
            if addRecord(record, to: waitingBookings) {
                self.presentationDelegate?.didUpdateWaitingList()
            }
        }

        if record.isHistoryRecord {
            if addRecord(record, to: historyBookings) {
                self.presentationDelegate?.didUpdateHistoryList()
            }
        }
    }

    func didUpdateBookRecord(_ record: BookRecord) {
        if record.isPendingAdmission {
            currentBookings.update(to: record)
            self.presentationDelegate?.didUpdateCurrentList()
        }

        if record.isAdmitted {
            if self.currentBookings.remove(record) {
                self.presentationDelegate?.didUpdateCurrentList()
            }
            if self.waitingBookings.add(record) {
                self.presentationDelegate?.didUpdateWaitingList()
            }
        }

        if record.isHistoryRecord {
            if self.waitingBookings.remove(record) {
                self.presentationDelegate?.didUpdateWaitingList()
            }

            if self.historyBookings.add(record) {
                self.presentationDelegate?.didUpdateHistoryList()
            }
        }
    }

    func didDeleteBookRecord(_ record: BookRecord) {
        if record.isPendingAdmission {
            if self.currentBookings.remove(record) {
                self.presentationDelegate?.didUpdateCurrentList()
            }
        }

        if record.isAdmitted {
            if self.waitingBookings.remove(record) {
                self.presentationDelegate?.didUpdateWaitingList()
            }
        }
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

    func admitCustomer(record: QueueRecord, completion: @escaping () -> Void) {
        // Set the serveTime of the queue record
        var new = record
        new.admitTime = currentTime()

        queueStorage.updateRecord(oldRecord: record, newRecord: new, completion: {
            completion()
            self.notifyCustomerOfAdmission(record: new)
        })
    }

    func admitCustomer(record: BookRecord, completion: @escaping () -> Void) {
        // Set the serveTime of the queue record
        var new = record
        new.admitTime = currentTime()

        bookingStorage.updateRecord(oldRecord: record, newRecord: new, completion: {
            completion()
        })
    }

    func serveCustomer(record: QueueRecord, completion: @escaping () -> Void) {
        var new = record
        new.serveTime = currentTime()

        queueStorage.updateRecord(oldRecord: record, newRecord: new, completion: {
            completion()
        })
    }

    func serveCustomer(record: BookRecord, completion: @escaping () -> Void) {
        var new = record
        new.serveTime = currentTime()

        bookingStorage.updateRecord(oldRecord: record, newRecord: new, completion: {
            completion()
        })
    }

    func rejectCustomer(record: QueueRecord, completion: @escaping () -> Void) {
        var new = record
        new.rejectTime = currentTime()

        queueStorage.updateRecord(oldRecord: record, newRecord: new, completion: {
            completion()
        })
    }

    func rejectCustomer(record: BookRecord, completion: @escaping () -> Void) {
        var new = record
        new.rejectTime = currentTime()

        bookingStorage.updateRecord(oldRecord: record, newRecord: new, completion: {
            completion()
        })
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

extension RestaurantQueueLogicManager {
    // Singleton created upon successful login
    private static var queueLogic: RestaurantQueueLogicManager?

    /// Returns shared restaurant queue logic manager for the logged in application. If it does not exist,
    /// a queue logic manager is initiailised with the given restaurant identity to share.
    static func shared(for restaurantIdentity: Restaurant? = nil) -> RestaurantQueueLogicManager {
        if let logic = queueLogic {
            return logic
        }

        assert(restaurantIdentity != nil,
               "Restaurant identity must be given non-nil to make the restaurant's queue logic manager.")
        let logic = RestaurantQueueLogicManager(restaurant: restaurantIdentity!)
        logic.queueStorage.logicDelegate = logic
        logic.bookingStorage.logicDelegate = logic

        queueLogic = logic
        return logic
    }

    static func deinitShared() {
        queueLogic = nil
    }
}

extension RestaurantQueueLogicManager {
    private func currentTime() -> Date {
        Date()
    }
}

import Foundation
class RestaurantQueueLogicManager: RestaurantQueueLogic {

    // Storage
    private(set) var queueStorage: RestaurantQueueStorage

    // View Controller
    weak var presentationDelegate: RestaurantQueueLogicPresentationDelegate?

    private init(restaurant: Restaurant) {
        self.restaurant = restaurant

        queueStorage = FBQueueStorage(restaurant: restaurant)
        fetchCurrent()
        fetchWaiting()
        fetchHistory()
    }

    private var restaurant: Restaurant
    private(set) var current = RecordCollection<QueueRecord>()
    private(set) var waiting = RecordCollection<QueueRecord>()
    private(set) var history = RecordCollection<QueueRecord>()

    var currentRecords: [Record] {
        current.records
    }

    var waitingRecords: [Record] {
        waiting.records
    }

    var historyRecords: [Record] {
        history.records
    }
    
    var isQueueOpen: Bool {
        restaurant.isQueueOpen
    }

    func fetchCurrent() {
        // Fetch the current queue from db
        queueStorage.loadQueue(of: restaurant, completion: {_ in })
    }

    func fetchWaiting() {
        queueStorage.loadWaitingList(of: restaurant, completion: {_ in })
    }

    func fetchHistory() {
        queueStorage.loadHistory(of: restaurant, completion: {_ in })
    }

    func didAddQueueRecord(_ record: QueueRecord) {
        if record.isPendingAdmission {
            if addRecord(record, to: current) {
                self.presentationDelegate?.didUpdateCurrentList()
            }
        }

        if record.isAdmitted {
            if addRecord(record, to: waiting) {
                self.presentationDelegate?.didUpdateWaitingList()
            }
        }

        if record.isHistoryRecord {
            if addRecord(record, to: history) {
                self.presentationDelegate?.didUpdateHistoryList()
            }
        }
    }

    func addRecord(_ record: QueueRecord, to list: RecordCollection<QueueRecord>) -> Bool {
        list.add(record)
    }

    func didUpdateQueueRecord(_ record: QueueRecord) {
        if record.isPendingAdmission {
            current.update(to: record)
            self.presentationDelegate?.didUpdateCurrentList()
        }

        if record.isAdmitted {
            if self.current.remove(record) {
                self.presentationDelegate?.didUpdateCurrentList()
            }
            if self.waiting.add(record) {
                self.presentationDelegate?.didUpdateWaitingList()
            }
        }

        if record.isHistoryRecord {
            if self.waiting.remove(record) {
                self.presentationDelegate?.didUpdateWaitingList()
            }

            if self.history.add(record) {
                self.presentationDelegate?.didUpdateHistoryList()
            }
        }
    }

    func didDeleteQueueRecord(_ record: QueueRecord) {
        if record.isPendingAdmission {
            if self.current.remove(record) {
                self.presentationDelegate?.didUpdateCurrentList()
            }
        }

        if record.isAdmitted {
            if self.waiting.remove(record) {
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

    func serveCustomer(record: QueueRecord, completion: @escaping () -> Void) {
        var new = record
        new.serveTime = currentTime()

        queueStorage.updateRecord(oldRecord: record, newRecord: new, completion: {
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

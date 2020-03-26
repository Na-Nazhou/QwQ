import Foundation
class RestaurantQueueLogicManager: RestaurantQueueLogic {

    // Storage
    private(set) var queueStorage: RestaurantQueueStorage

    // View Controller
    weak var presentationDelegate: RestaurantQueueLogicPresentationDelegate?

    private init(restaurant: Restaurant) {
        self.restaurant = restaurant

        queueStorage = FBQueueStorage(restaurant: restaurant)
        fetchQueue()
        fetchWaiting()
    }

    private var restaurant: Restaurant

    private(set) var queue = RestaurantQueue()
    private(set) var waiting = RestaurantQueue()

    var queueRecords: [Record] {
        queue.queue.records
    }
    
    var isQueueOpen: Bool {
        restaurant.isQueueOpen
    }

    func fetchQueue() {
        // Fetch the current queue from db
        queueStorage.loadQueue(of: restaurant, completion: {
            if $0 == nil {
                return
            }
            let didAddNew = self.queue.addToQueue($0!)
            if didAddNew {
                self.presentationDelegate?.didUpdateQueue()
            }
        })
    }

    func fetchWaiting() {
        queueStorage.loadWaitingList(of: restaurant, completion: {
            if $0 == nil {
                return
            }
            let didAddNew = self.queue.addToWaiting($0!)
            if didAddNew {
                self.presentationDelegate?.didUpdateQueue()
            }
        })
    }

    func didAddQueueRecord(_ record: QueueRecord) {
        self.presentationDelegate?.didUpdateQueue()
    }

    func didUpdateQueueRecord(_ record: QueueRecord) {
        self.presentationDelegate?.didUpdateQueue()
    }

    func didDeleteQueueRecord(_ record: QueueRecord) {
        self.presentationDelegate?.didUpdateQueue()
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

    func admitCustomer(record: QueueRecord) {
        // Set the serveTime of the queue record
        let admittedRecord = updateAdmitTime(queueRecord: record)
        queueStorage.updateRecord(oldRecord: record, newRecord: admittedRecord, completion: {
            if self.queue.removeFromQueue(record) {
                self.presentationDelegate?.didUpdateQueue()
            }
            if self.queue.addToWaiting(record) {
                self.presentationDelegate?.didUpdateQueue()
            }

            self.notifyCustomerOfAdmission(record: admittedRecord)
        })
    }

    func serveCustomer(record: QueueRecord) {
        //TODO like rejectCustomerrestau
    }

    func rejectCustomer(record: QueueRecord) {
        //TODO: when remove is allowed only at waiting list
        // then allow reject at waiting list
        // to be consistent with customer app model
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

    private func updateAdmitTime(queueRecord: QueueRecord) -> QueueRecord {
        var updatedRec = queueRecord
        updatedRec.admitTime = currentTime()
        return updatedRec
    }
}

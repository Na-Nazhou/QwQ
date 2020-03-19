import Foundation
class RestaurantQueueLogicManager: RestaurantQueueLogic {
    weak var presentationDelegate: RestaurantQueueLogicPresentationDelegate?

    private init(restaurant: Restaurant) {
        self.restaurant = restaurant
        queueStorage = RestaurantQueueStorageStub()
    }

    private var restaurant: Restaurant
    var queueStorage: RestaurantQueueStorage

    var restaurantQueue = RestaurantQueue()

    func fetchQueue() {
        // Fetch the current queue from db
        queueStorage.loadQueue(of: restaurant, completion: {
            if $0 == nil {
                return
            }
            let didAddNew = self.restaurantQueue.addToQueue($0!)
            if didAddNew {
                self.presentationDelegate?.logicDidAddRecordToQueue(with: $0!)
            }
        })
    }

    func fetchWaiting() {
        queueStorage.loadWaitingList(of: restaurant, completion: {
            if $0 == nil {
                return
            }
            let didAddNew = self.restaurantQueue.addToWaiting($0!)
            if didAddNew {
                self.presentationDelegate?.logicDidAddRecordToWaiting(record: $0!)
            }
        })
    }

    func openQueue() {
        assert(!restaurant.isQueueOpen, "Queue should be closed to open.")
        queueStorage.openQueue(of: restaurant, at: currentTime())
    }

    func closeQueue() {
        assert(restaurant.isQueueOpen, "Queue should be open to close.")
        queueStorage.closeQueue(of: restaurant, at: currentTime())
    }

    func admitCustomer(record: QueueRecord) {
        // Set the serveTime of the queue record
        let admittedRecord = updateAdmitTime(queueRecord: record)
        queueStorage.admitCustomer(record: admittedRecord)
        if restaurantQueue.removeFromQueue(record) {
            presentationDelegate?.logicDidRemoveRecordFromQueue(queueRecord: record)
        }
        if restaurantQueue.addToWaiting(record) {
            presentationDelegate?.logicDidAddRecordToWaiting(record: record)
        }

        notifyCustomerOfAdmission(record: admittedRecord)
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
    func restaurantDidOpenQueue(restaurant: Restaurant) {
        if restaurant != self.restaurant {
            //all endpoints get notified, but if does not pertain to itself, nothing is done.
            return
        }
        presentationDelegate?.restaurantDidOpenQueue()
    }

    func restaurantDidCloseQueue(restaurant: Restaurant) {
        if restaurant != self.restaurant {
            return
        }
        presentationDelegate?.restaurantDidCloseQueue()
    }

    func customerDidJoinQueue(with record: QueueRecord) {
        if restaurantQueue.addToQueue(record) {
            presentationDelegate?.logicDidAddRecordToQueue(with: record)
        }
        // TODO: notify/alert that customer had joined queue
    }

    func customerDidUpdateQueueRecord(to new: QueueRecord) {
        let (didUpdate, old) = restaurantQueue.updateRecInQueue(to: new)
        if didUpdate {
            presentationDelegate?.logicDidModifyRecordInQueue(from: old!, to: new)
        }
        // TODO: notify/alert that customer had made changes
    }

    func customerDidWithdrawQueue(record: QueueRecord) {
        // delete the queue record from the current queue
        presentationDelegate?.logicDidRemoveRecordFromQueue(queueRecord: record)
        // TODO: notify/alert that customer had quit queue
    }

    func restaurantDidAdmitCustomer(record: QueueRecord) {
        presentationDelegate?.logicDidRemoveRecordFromQueue(queueRecord: record)
        presentationDelegate?.logicDidAddRecordToWaiting(record: record)
    }

    func restaurantDidServeCustomer(record: QueueRecord) {
        presentationDelegate?.logicDidRemoveRecordFromWaiting(record: record)
    }

    func restaurantDidRejectCustomer(record: QueueRecord) {
        presentationDelegate?.logicDidRemoveRecordFromWaiting(record: record)
        //TODO: add back to end of queue?
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
        logic.queueStorage.queueModificationLogicDelegate = logic
        logic.queueStorage.queueStatusLogicDelegate = logic
        return logic
    }

    static func deinitShared() {
        queueLogic = nil
    }
}

extension RestaurantQueueLogicManager {
    private func currentTime() -> Date {
        return Date()
    }
    private func updateAdmitTime(queueRecord: QueueRecord) -> QueueRecord {
        var updatedRec = queueRecord
        updatedRec.admitTime = currentTime()
        return updatedRec
    }
}

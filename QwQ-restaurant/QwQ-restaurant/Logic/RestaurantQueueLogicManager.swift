import Foundation
class RestaurantQueueLogicManager: RestaurantQueueLogic {
    weak var presentationDelegate: RestaurantQueueLogicPresentationDelegate?

    // Singleton created upon successful login
    private static var queueLogic: RestaurantQueueLogicManager?

    /// Returns shared restaurant queue logic manager for the logged in application. If it does not exist,
    /// a queue logic manager is initiailised with the given restaurant identity to share.
    static func shared(for restaurantIdentity: Restaurant?) -> RestaurantQueueLogicManager {
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

    private init(restaurant: Restaurant) {
        self.restaurant = restaurant
        queueStorage = RestaurantQueueStorageStub()
    }

    private var restaurant: Restaurant
    var queueStorage: RestaurantQueueStorage

    var restaurantQueue = RestaurantQueue()

    func loadQueue() -> [QueueRecord] {
        // Fetch the current queue from db
        return queueStorage.loadQueue(of: restaurant)
    }

    func loadWaiting() -> [QueueRecord] {
        return queueStorage.loadWaitingList(of: restaurant)
    }

    func openQueue() {
        // Set the openTime of the queue
        queueStorage.openQueue(of: restaurant, at: currentTime())
    }

    func closeQueue() {
        // Set the closeTime of the queue
        queueStorage.closeQueue(of: restaurant, at: currentTime())
    }

    func admitCustomer(record: QueueRecord) {
        // Set the serveTime of the queue record
        let admittedRecord = updateAdmitTime(queueRecord: record)
        // Remove the queue record from the current queue
        queueStorage.removeCustomerFromQueue(record: record)
        queueStorage.admitCustomer(record: admittedRecord)

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
        // Add the queue record to the queue
        presentationDelegate?.logicDidAddRecordToQueue(with: record)
        // TODO: notify/alert that customer had joined queue
    }

    func customerDidUpdateQueueRecord(from old: QueueRecord, to new: QueueRecord) {
        // Update the queue record in the current queue
        presentationDelegate?.logicDidModifyRecordInQueue(from: old, to: new)
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
    private func currentTime() -> Date {
        return Date()
    }
    private func updateAdmitTime(queueRecord: QueueRecord) -> QueueRecord {
        var updatedRec = queueRecord
        updatedRec.admitTime = currentTime()
        return updatedRec
    }
}

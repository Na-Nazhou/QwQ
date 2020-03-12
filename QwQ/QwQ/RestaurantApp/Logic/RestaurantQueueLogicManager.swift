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

    private init(restaurant: Restaurant) {
        self.restaurant = restaurant
    }

    private var restaurant: Restaurant
    var queueStorage: RestaurantQueueStorage = RestaurantQueueStorageStub()

    var restaurantQueue = RestaurantQueue()

    func loadQueue() {
        // Fetch the current queue from db
        queueStorage.loadQueue(of: restaurant)
        // TODO: Feedback to views
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

    func restaurantDidOpenQueue(restaurant: Restaurant) {
        //
    }

    func restaurantDidCloseQueue(restaurant: Restaurant) {
        //
    }

    func customerDidJoinQueue(with record: QueueRecord) {
        // Add the queue record to the queue
    }

    func customerDidUpdateQueueRecord(from old: QueueRecord, to new: QueueRecord) {
        // Update the queue record in the current queue
    }

    func customerDidWithdrawQueue(record: QueueRecord) {
        // delete the queue record from the current queue
    }

    func restaurantDidAdmitCustomer(record: QueueRecord) {
        //
    }
    func restaurantDidServeCustomer(record: QueueRecord) {
        //
    }
    func restaurantDidRejectCustomer(record: QueueRecord) {
        //
    }
    func restaurantDidRemoveQueueRecord(record: QueueRecord) {
        //
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

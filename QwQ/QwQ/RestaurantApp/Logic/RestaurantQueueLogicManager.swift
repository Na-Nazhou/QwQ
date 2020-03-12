import Foundation
class RestaurantQueueLogicManager: RestaurantQueueLogic {
    // Singleton created upon successful login
    private var queueLogic: RestaurantQueueLogicManager?

    static func shared(for restaurantIdentity: Restaurant?) -> RestaurantQueueLogicManager {
        if let logic = queueLogic {
            return logic
        }
        return RestaurantQueueLogicManager(restaurantIdentity)
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

    func admitCustomer(record: RestaurantQueueRecord) {
        // Set the serveTime of the queue record
        let admittedRecord = updateAdmitTime(queueRecord: record)
        // Remove the queue record from the current queue
        queueStorage.removeCustomerFromQueue(record: record)
        queueStorage.admitCustomer(record: admittedRecord)

        notifyCustomerOfAdmission()
    }

    func notifyCustomerOfAdmission(record: RestaurantQueueRecord) {
        //setup timer events
    }

    func notifyCustomerOfRejection(record: RestaurantQueueRecord) {
        // send one time message to tell customer it has taken them __ min but hasnt arrived so they kicked them out or sth
    }

    func didAddQueueRecord(record: RestaurantQueueRecord) {
        // Add the queue record to the queue
    }

    func didUpdateQueueRecord(old: RestaurantQueueRecord, new: RestaurantQueueRecord) {
        // Update the queue record in the current queue
    }

    func didDeleteQueueRecord(record: RestaurantQueueRecord) {
        // delete the queue record from the current queue
    }
}

extension RestaurantQueueLogicManager {
    private func currentTime() -> Date {
        return Date()
    }
    private func updateAdmitTime(queueRecord: RestaurantQueueRecord) -> RestaurantQueueRecord {
        queueRecord.admitTime = currentTime()
        return queueRecord
    }
}

class RestaurantQueueLogicManager: RestaurantQueueLogic {
    var queueStorage: RestaurantQueueStorage = RestaurantQueueStorageStub()

    var restaurantQueue = RestaurantQueue()

    func loadQueue() {
        // Fetch the current queue from db
    }

    func openQueue() {
        // Set the openTime of the queue
    }

    func closeQueue() {
        // Set the closeTime of the queue
    }

    func admitCustomer(record: RestaurantQueueRecord) {
        // Set the serveTime of the queue record
        // Remove the queue record from the current queue
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

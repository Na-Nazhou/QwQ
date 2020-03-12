protocol RestaurantQueueLogicPresentationDelegate {
    func restaurantDidOpenQueue()
    func restaurantDidCloseQueue()

    func removeFromQueue(queueRecord: RestaurantQueueRecord)
}

protocol RestaurantQueueLogic: QueueStorageSyncDelegate, QueueOpenCloseSyncDelegate {
    var presentationDelegate: RestaurantQueueLogicPresentationDelegate? { get set }

    var queueStorage: RestaurantQueueStorage { get set }
    var restaurantQueue: RestaurantQueue { get set }

    func loadQueue()
    /// Opens queue and registers the opening time of the restaurant as the current time.
    func openQueue()
    /// Closes queue and registers the closing time of the restaurant as the current time.
    func closeQueue()

    /// Dequeues and admits customer.
    func admitCustomer(record: QueueRecord)
    /// Notifies customer every 5 min while customer is in admitted state.
    func notifyCustomerOfAdmission(record: QueueRecord)
    func notifyCustomerOfRejection(record: QueueRecord)
}

protocol RestaurantQueueLogicPresentationDelegate: AnyObject {
    func restaurantDidChangeQueueStatus(toIsOpen: Bool)

    func didAddRecordToQueue(record: QueueRecord)
    func didRemoveRecordFromQueue(record: QueueRecord)
    func didUpdateRecordInQueue(to new: QueueRecord)

    func didAddRecordToWaiting(toWaiting record: QueueRecord)
    func didRemoveRecordFromWaiting(record: QueueRecord)
}

protocol RestaurantQueueLogic: QueueStorageSyncDelegate, QueueOpenCloseSyncDelegate {
    var presentationDelegate: RestaurantQueueLogicPresentationDelegate? { get set }

    var queueStorage: RestaurantQueueStorage { get set }
    var restaurantQueue: RestaurantQueue { get set }

    /// Loads the active queue records of the restaurant.
    func fetchQueue()
    /// Loads the list of customers the restaurant is waiting to turn up after being admitted.
    func fetchWaiting()
    /// Opens queue and registers the opening time of the restaurant as the current time.
    func openQueue()
    /// Closes queue and registers the closing time of the restaurant as the current time.
    func closeQueue()

    /// Dequeues and admits customer.
    func admitCustomer(record: QueueRecord)
    /// Notifies customer every 5 min while customer is in admitted state.
    func notifyCustomerOfAdmission(record: QueueRecord)
    func notifyCustomerOfRejection(record: QueueRecord)
    func alertRestaurantIfCustomerTookTooLongToArrive(record: QueueRecord)
}

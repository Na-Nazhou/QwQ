protocol RestaurantQueueLogicPresentationDelegate: AnyObject {
    func restaurantDidOpenQueue()
    func restaurantDidCloseQueue()

    func logicDidAddRecordToQueue(with record: QueueRecord)
    func logicDidRemoveRecordFromQueue(queueRecord: QueueRecord)
    func logicDidModifyRecordInQueue(from old: QueueRecord, to new: QueueRecord)

    func logicDidAddRecordToWaiting(record: QueueRecord)
    func logicDidRemoveRecordFromWaiting(record: QueueRecord)
}

protocol RestaurantQueueLogic: QueueStorageSyncDelegate, QueueOpenCloseSyncDelegate {
    var presentationDelegate: RestaurantQueueLogicPresentationDelegate? { get set }

    var queueStorage: RestaurantQueueStorage { get set }
    var restaurantQueue: RestaurantQueue { get set }

    /// Loads and returns the active queue records of the restaurant.
    func loadQueue() -> [QueueRecord]
    /// Loads and returns the list of customers the restaurant is waiting to turn up after being admitted.
    func loadWaiting() -> [QueueRecord]
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

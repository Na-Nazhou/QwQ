protocol RestaurantQueueLogic: QueueStorageSyncDelegate {
    var presentationDelegate: RestaurantQueueLogicPresentationDelegate? { get set }

    var queueStorage: RestaurantQueueStorage { get }
    var restaurantQueue: RestaurantQueue { get }
    var restaurantWaiting: RestaurantQueue { get }

    /// Loads the active queue records of the restaurant.
    func fetchQueue()
    /// Loads the list of customers the restaurant is waiting to turn up after being admitted.
    func fetchWaiting()
    /// Opens queue anfethadd registers the opening time of the restaurant as the current time.
    func openQueue()
    /// Closes queue and registers the closing time of the restaurant as the current time.
    func closeQueue()

    /// Dequeues and admits customer.
    func admitCustomer(record: QueueRecord)
    func serveCustomer(record: QueueRecord)
    func rejectCustomer(record: QueueRecord)
    /// Notifies customer every 5 min while customer is in admitted state.
    func notifyCustomerOfAdmission(record: QueueRecord)
    func notifyCustomerOfRejection(record: QueueRecord)
    func alertRestaurantIfCustomerTookTooLongToArrive(record: QueueRecord)
}

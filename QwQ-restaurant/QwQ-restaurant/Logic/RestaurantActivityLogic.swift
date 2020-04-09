protocol RestaurantActivityLogic: QueueStorageSyncDelegate, BookingStorageSyncDelegate {

    // View Controllers
    var activitiesDelegate: ActivitiesDelegate? { get set }

    /// Opens queue anfethadd registers the opening time of the restaurant as the current time.
    func openQueue()
    /// Closes queue and registers the closing time of the restaurant as the current time.
    func closeQueue()

    /// Dequeues and admits customer.
    func admitCustomer(record: QueueRecord, completion: @escaping () -> Void)
    func serveCustomer(record: QueueRecord, completion: @escaping () -> Void)
    func rejectCustomer(record: QueueRecord, completion: @escaping () -> Void)

    /// Notifies customer every 5 min while customer is in admitted state.
    func notifyCustomerOfAdmission(record: QueueRecord)
    func notifyCustomerOfRejection(record: QueueRecord)
    func alertRestaurantIfCustomerTookTooLongToArrive(record: QueueRecord)

}

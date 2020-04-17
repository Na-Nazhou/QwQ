protocol RestaurantActivityLogic: QueueStorageSyncDelegate, BookingStorageSyncDelegate {

    // View Controllers
    var activitiesDelegate: ActivitiesDelegate? { get set }

    // Models
    var currentRecords: [Record] { get }
    var waitingRecords: [Record] { get }
    var historyRecords: [Record] { get }

    /// Dequeues and admits customer.
    func admitCustomer(record: QueueRecord, completion: @escaping () -> Void)
    func serveCustomer(record: QueueRecord, completion: @escaping () -> Void)
    func rejectCustomer(record: QueueRecord, completion: @escaping () -> Void)
    func admitCustomer(record: BookRecord, completion: @escaping () -> Void)
    func serveCustomer(record: BookRecord, completion: @escaping () -> Void)
    func rejectCustomer(record: BookRecord, completion: @escaping () -> Void)

    // TODO
    /// Notifies customer every 5 min while customer is in admitted state.
    func notifyCustomerOfAdmission(record: QueueRecord)
    func notifyCustomerOfRejection(record: QueueRecord)
    func alertRestaurantIfCustomerTookTooLongToArrive(record: QueueRecord)

}

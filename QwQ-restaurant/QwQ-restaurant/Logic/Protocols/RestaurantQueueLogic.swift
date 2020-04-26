/// Represents the protocol a logic handler of restaurant queues should conform to.
protocol RestaurantQueueLogic: QueueStorageSyncDelegate {

    /// Presentation delegate of queue activities.
    var activitiesDelegate: ActivitiesDelegate? { get set }

    /// Admits the customer's `record` and performs `completion` when successful.
    func admitCustomer(record: QueueRecord, completion: @escaping () -> Void)
    /// Serves the customer's `record` and performs `completion` when successful.
    func serveCustomer(record: QueueRecord, completion: @escaping () -> Void)
    /// Rejects the customer's `record` and performs `completion` when successful.
    func rejectCustomer(record: QueueRecord, completion: @escaping () -> Void)
    /// Misses the customer's `record` and performs `completion` when successful.
    func missCustomer(record: QueueRecord, completion: @escaping () -> Void)
}

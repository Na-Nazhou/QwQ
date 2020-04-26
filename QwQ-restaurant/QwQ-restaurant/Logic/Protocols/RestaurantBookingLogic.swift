/// Represents the protocol a logic handler of restaurant queues should conform to.
protocol RestaurantBookingLogic: BookingStorageSyncDelegate {

    /// Presentation delegate of booking activities.
    var activitiesDelegate: ActivitiesDelegate? { get set }
    
    /// Admits and accepts the customer's `record` and performs `completion` when successful.
    func admitCustomer(record: BookRecord, completion: @escaping () -> Void)
    /// Serves the customer's `record` and performs `completion` when successful.
    func serveCustomer(record: BookRecord, completion: @escaping () -> Void)
    /// Rejects the customer's `record` and performs `completion` when successful.
    func rejectCustomer(record: BookRecord, completion: @escaping () -> Void)
}

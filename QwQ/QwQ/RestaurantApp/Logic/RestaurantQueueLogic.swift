protocol RestaurantQueueStorageSyncDelegate: AnyObject {
    func didAddQueueRecord(record: RestaurantQueueRecord)
    func didUpdateQueueRecord(old: RestaurantQueueRecord, new: RestaurantQueueRecord)
    func didDeleteQueueRecord(record: RestaurantQueueRecord)
}

protocol RestaurantQueueLogic: RestaurantQueueStorageSyncDelegate {
    var queueStorage: RestaurantQueueStorage { get set }
    var restaurantQueue: RestaurantQueue { get set }

    func loadQueue()
    func openQueue()
    func closeQueue()

    func admitCustomer(record: RestaurantQueueRecord)
}

protocol RestaurantQueueStorageSync {
    var logicDelegate: RestaurantQueueStorageSyncDelegate? { get set }

    func didAddQueueRecord(record: RestaurantQueueRecord)
    func didUpdateQueueRecord(old: RestaurantQueueRecord, new: RestaurantQueueRecord)
    func didDeleteQueueRecord(record: RestaurantQueueRecord)
}

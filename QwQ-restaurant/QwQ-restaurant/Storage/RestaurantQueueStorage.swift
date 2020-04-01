import Foundation

/// Represents the univeral queue storage sync protocol.
protocol QueueStorageSync {
    var logicDelegates: NSHashTable<AnyObject> { get }

    func registerDelegate(_ del: QueueStorageSyncDelegate)
    func unregisterDelegate(_ del: QueueStorageSyncDelegate)

    func registerListeners(for restaurant: Restaurant)
    func removeListeners()
}

protocol RestaurantQueueStorage: QueueStorageSync {
    // MARK: - Modifier
    func updateRestaurantQueueStatus(old: Restaurant, new: Restaurant)

    func updateRecord(oldRecord: QueueRecord, newRecord: QueueRecord,
                      completion: @escaping () -> Void)
}

import Foundation

/// Represents the univeral queue storage sync protocol.
protocol QueueStorageSync {
    var logicDelegate: QueueStorageSyncDelegate? { get set }
}

protocol RestaurantQueueStorage: QueueStorageSync {

    // MARK: - Modifier

    func updateRestaurantQueueStatus(old: Restaurant, new: Restaurant)

    func updateRecord(oldRecord: QueueRecord, newRecord: QueueRecord,
                      completion: @escaping () -> Void)
}

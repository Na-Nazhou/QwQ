import Foundation

/// Represents the univeral queue storage sync protocol.
protocol QueueStorageSync {
    var logicDelegates: NSHashTable<AnyObject> { get }

    func registerDelegate(_ del: QueueStorageSyncDelegate)

    func unregisterDelegate(_ del: QueueStorageSyncDelegate)

    // MARK: - Listeners
    func registerListener(for customer: Customer)

    func removeListener()
}

protocol CustomerQueueStorage: QueueStorageSync {
    // MARK: - Modifier
    /// Insert a queue record
    func addQueueRecord(newRecord: QueueRecord, completion: @escaping () -> Void)

    func addQueueRecords(newRecords: [QueueRecord], completion: @escaping () -> Void)

    /// Update a queue record (can only update groupSize, babyCount, wheelchairCount)
    func updateQueueRecord(oldRecord: QueueRecord, newRecord: QueueRecord, completion: @escaping () -> Void)

    func updateQueueRecords(newRecords: [QueueRecord], completion: @escaping () -> Void)
}

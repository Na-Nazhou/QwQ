import Foundation

/// Represents the univeral queue storage sync protocol.
protocol QueueStorageSync {
    var logicDelegates: NSHashTable<AnyObject> { get }

    func registerDelegate(_ del: QueueStorageSyncDelegate)

    func unregisterDelegate(_ del: QueueStorageSyncDelegate)

    // MARK: - Listeners
    func registerListener(for record: QueueRecord)

    func removeListener(for record: QueueRecord)
}

protocol CustomerQueueStorage: QueueStorageSync {
    // MARK: - Modifier
    /// Insert a queue record
    func addQueueRecord(newRecord: QueueRecord, completion: @escaping (_ id: String) -> Void)

    /// Update a queue record (can only update groupSize, babyCount, wheelchairCount)
    func updateQueueRecord(oldRecord: QueueRecord, newRecord: QueueRecord, completion: @escaping () -> Void)

    /// Delete a queue record
    func deleteQueueRecord(record: QueueRecord, completion: @escaping () -> Void)

    // MARK: - Query
    /// Calls  completion handler when it finds customer's active queue record.
    func loadActiveQueueRecords(customer: Customer, completion: @escaping (QueueRecord?) -> Void)

    func loadQueueHistory(customer: Customer, completion: @escaping (QueueRecord?) -> Void)
}

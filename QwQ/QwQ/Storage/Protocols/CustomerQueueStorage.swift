import Foundation

protocol QueueStorageSync {

    // MARK: - Listeners
    func registerListener(for customer: Customer)

    func removeListener()

    // MARK: - Delegates
    func registerDelegate(_ del: QueueStorageSyncDelegate)

    func unregisterDelegate(_ del: QueueStorageSyncDelegate)
}

protocol CustomerQueueStorage: QueueStorageSync {
    // MARK: - Modifiers

    /// Insert multiple queue records
    func addQueueRecords(newRecords: [QueueRecord], completion: @escaping () -> Void)

    /// Update a queue record
    func updateQueueRecord(oldRecord: QueueRecord, newRecord: QueueRecord,
                           completion: @escaping () -> Void)

    /// Update multiple queue records
    func updateQueueRecords(newRecords: [QueueRecord], completion: @escaping () -> Void)
}

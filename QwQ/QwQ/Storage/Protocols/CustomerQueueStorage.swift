/// Represents the protocol a synchronizable storage component should conform to for queues.
protocol QueueStorageSync {

    // MARK: - Listeners
    /// Register to listen to all queue records of `customer`.
    func registerListener(for customer: Customer)

    /// Removes any registered listener.
    func removeListener()

    // MARK: - Delegates
    /// Register `del` as a delegate of this component.
    func registerDelegate(_ del: QueueStorageSyncDelegate)

    /// Unregister `del` from this component.
    func unregisterDelegate(_ del: QueueStorageSyncDelegate)
}

/// Represents the protocol a customer queue storage component should conform to.
protocol CustomerQueueStorage: QueueStorageSync {
    // MARK: - Modifiers
    /// Inserts multiple queue records to the collection of queue records.
    func addQueueRecords(newRecords: [QueueRecord], completion: @escaping () -> Void)

    /// Updates a queue record in collection from `oldRecord` to `newRecord`.
    func updateQueueRecord(oldRecord: QueueRecord, newRecord: QueueRecord,
                           completion: @escaping () -> Void)

    /// Updates multiple queue records to the records in `newRecord`.
    func updateQueueRecords(newRecords: [QueueRecord], completion: @escaping () -> Void)
}

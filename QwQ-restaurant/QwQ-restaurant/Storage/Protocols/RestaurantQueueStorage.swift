/// Represents the protocol a synchronizable storage component should conform to for queues.
protocol QueueStorageSync {

    // MARK: - Listeners
    /// Register to listen to all queue records of `restaurant`.
    func registerListener(for restaurant: Restaurant)
    
    /// Removes any registered listener.
    func removeListener()

    // MARK: - Delegates
    /// Register `del` as a delegate of this component.
    func registerDelegate(_ del: QueueStorageSyncDelegate)
    
    /// Unregister `del` from this component.
    func unregisterDelegate(_ del: QueueStorageSyncDelegate)

}

/// Represents the protocol a restaurant queue storage component should conform to.
protocol RestaurantQueueStorage: QueueStorageSync {
    // MARK: - Modifiers
    /// Updates a queue record in collection from `oldRecord` to `newRecord`.
    func updateRecord(oldRecord: QueueRecord, newRecord: QueueRecord,
                      completion: @escaping () -> Void)
    
    /// Updates multiple queue records to the records in `newRecord`.
    func updateRecords(newRecords: [QueueRecord], completion: @escaping () -> Void)
}

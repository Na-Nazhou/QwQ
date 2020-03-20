protocol CustomerQueueStorage: QueueStorageSync {
    // MARK: - Modifier

    /// Insert a queue record
    func addQueueRecord(record: QueueRecord, completion: @escaping (String) -> Void)
    /// Update a queue record (can only update groupSize, babyCount, wheelchairCount)
    func updateQueueRecord(old: QueueRecord, new: QueueRecord, completion:  @escaping () -> Void)
    /// Delete a queue record
    func deleteQueueRecord(record: QueueRecord, completion:  @escaping () -> Void)

    // MARK: - Query
    /// Calls  completion handler when it finds customer's active queue record.
    func loadQueueRecord(customer: Customer, completion: @escaping (QueueRecord?) -> Void)

    func loadQueueHistory(customer: Customer, completion: @escaping (QueueRecord?) -> Void)
}

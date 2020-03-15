protocol CustomerQueueStorage: QueueStorageSync {
    // MARK: - Modifier

    /// Insert a queue record
    func addQueueRecord(record: QueueRecord)
    /// Update a queue record (can only update groupSize, babyCount, wheelchairCount)
    func updateQueueRecord(old: QueueRecord, new: QueueRecord)
    /// Delete a queue record
    func deleteQueueRecord(record: QueueRecord)

    // MARK: - Query
    /// Return the current queue record (if any)
    func loadQueueRecord() -> QueueRecord?
}

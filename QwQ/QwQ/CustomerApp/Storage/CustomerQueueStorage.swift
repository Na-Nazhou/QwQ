protocol CustomerQueueStorage {
    // MARK: - Modifier

    /// Insert a queue record
    func addQueueRecord(record: CustomerQueueRecord)
    /// Update a queue record (only update in groupSize, babyCount, wheelchairCount)
    func updateQueueRecord(old: CustomerQueueRecord, new: CustomerQueueRecord)
    /// Delete a queue record
    func deleteQueueRecord(record: CustomerQueueRecord)

    // MARK: - Query
    /// Return the current queue record (if any)
    func loadQueueRecord() -> CustomerQueueRecord?
}

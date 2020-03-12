/// Represents the storage handler for events trigerred upstream in-application.
protocol QueueStorage {
    // MARK: - Modifier
    func addQueueRecord(record: QueueRecord)
    func removeQueueRecord(record: QueueRecord)
    func updateQueueRecord(record: QueueRecord)

    // MARK: - Query
//    func isQueueOpen(for restaurant: Restaurant, at time: Date) -> Bool
}

/// Represents the protocol any queue storage syncing delegates need to conform to.
protocol QueueStorageSyncDelegate: AnyObject {
    
    /// Adds record to collection of queue records.
    func didAddQueueRecord(_ record: QueueRecord)

    /// Updates collection of queue records when updated.
    func didUpdateQueueRecord(_ record: QueueRecord)

}

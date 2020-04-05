/// Represents the protocol any queue storage syncing delegates need to conform to.
protocol QueueStorageSyncDelegate: AnyObject {

    /// Updates collection of queue records when updated.
    func didUpdateQueueRecord(_ record: QueueRecord)

}

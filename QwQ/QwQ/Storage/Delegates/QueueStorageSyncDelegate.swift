/// Represents the protocol any queue storage syncing delegates need to conform to.
protocol QueueStorageSyncDelegate: AnyObject {

    func didAddQueueRecord(_ record: QueueRecord)

    /// Updates collection of queue records when updated.
    func didUpdateQueueRecord(_ record: QueueRecord)

}

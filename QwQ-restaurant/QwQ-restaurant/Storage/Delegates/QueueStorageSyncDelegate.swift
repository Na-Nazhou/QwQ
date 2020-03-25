/// Represents the protocol any queue storage syncing delegates need to conform to.
protocol QueueStorageSyncDelegate: AnyObject {

    func didAddQueueRecord(_ record: QueueRecord)

    func didUpdateQueueRecord(_ record: QueueRecord)

    func didDeleteQueueRecord(_ record: QueueRecord)
}

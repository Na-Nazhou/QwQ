/// Represents the protocol any queue storage syncing delegates need to conform to.
protocol QueueStorageSyncDelegate: AnyObject {

    func didDeleteQueueRecord(_ record: QueueRecord)

    func didUpdateQueueRecord(_ record: QueueRecord)

    // Customer actions synced from other devices -- TODO?
//    func didAddQueueRecord(newRecord: QueueRecord)
}

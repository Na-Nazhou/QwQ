/// Represents the protocol any queue storage syncing delegates need to conform to.
protocol QueueStorageSyncDelegate: AnyObject {
    func restaurantDidAdmitCustomer(record: QueueRecord)
    // Supposing restaurant can only kick customers from waiting list and not the queue itself
    func restaurantDidRejectCustomer(record: QueueRecord)

    func customerDidDeleteActiveQueueRecord()
    func queueRecordDidUpdate(_ record: QueueRecord)
    // Customer actions synced from other devices -- TODO?
//    func queueRecordDidGetAdded(rec: QueueRecord)
//    func customerDidModifyQueueRecord(rec: QueueRecord)
}

protocol QueueOpenCloseSyncDelegate: AnyObject {
    /// Notify if restaurant is open.
    func restaurantDidOpenQueue(restaurant: Restaurant)
    /// Notify if restuarant is closed.
    func restaurantDidCloseQueue(restaurant: Restaurant)
}

/// Represents the univeral queue storage sync protocol.
protocol QueueStorageSync {
    var queueModificationLogicDelegate: QueueStorageSyncDelegate? { get set }
    var queueStatusLogicDelegate: QueueOpenCloseSyncDelegate? { get set }

    func didDetectAdmissionOfCustomer(record: QueueRecord)
    func didDetectRejectionOfCustomer(record: QueueRecord)

    func didDetectOpenQueue(restaurant: Restaurant)
    func didDetectCloseQueue(restaurant: Restaurant)
}

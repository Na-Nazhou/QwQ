/// Represents the protocol any queue storage syncing delegates need to conform to.
protocol QueueStorageSyncDelegate: AnyObject {
    func customerDidJoinQueue(with record: QueueRecord)
    func customerDidUpdateQueueRecord(to new: QueueRecord)
    func customerDidWithdrawQueue(record: QueueRecord)

    func restaurantDidAdmitCustomer(record: QueueRecord)
    func restaurantDidServeCustomer(record: QueueRecord)
    // Supposing restaurant can only kick customers from waiting list and not the queue itself
    func restaurantDidRejectCustomer(record: QueueRecord)
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

    // MARK: - Sync handlers
    //TODO: instead let logic handle what change in record it was. (from interacting with RQueue)
    func didDetectNewQueueRecord(record: QueueRecord)
    func didDetectQueueRecordUpdate(new: QueueRecord)
    func didDetectWithdrawnQueueRecord(record: QueueRecord)

    func didDetectAdmissionOfCustomer(record: QueueRecord)
    func didDetectServiceOfCustomer(record: QueueRecord)
    func didDetectRejectionOfCustomer(record: QueueRecord)

    func didDetectOpenQueue(restaurant: Restaurant)
    func didDetectCloseQueue(restaurant: Restaurant)
}

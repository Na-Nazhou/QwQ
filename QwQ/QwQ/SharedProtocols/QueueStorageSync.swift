/// Represents the protocol any queue storage syncing delegates need to conform to.
protocol QueueStorageSyncDelegate: AnyObject {
    func customerDidJoinQueue(with record: QueueRecord)
    func customerDidUpdateQueueRecord(from old: QueueRecord, to new: QueueRecord)
    func customerDidWithdrawQueue(record: QueueRecord)

    // if we allow restaurants to reject customers
    func restaurantDidRemoveQueueRecord(record: QueueRecord)

    func restaurantDidAdmitCustomer(record: QueueRecord)
    func restaurantDidServeCustomer(record: QueueRecord)
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
    func didDetectNewQueueRecord(record: QueueRecord)
    func didDetectQueueRecordUpdate(old: QueueRecord, new: QueueRecord)
    func didDetectWithdrawnQueueRecord(record: QueueRecord)

    func didDetectAdmissionOfCustomer(record: QueueRecord)

    func didDetectOpenQueue(restaurant: Restaurant)
    func didDetectCloseQueue(restaurant: Restaurant)
}

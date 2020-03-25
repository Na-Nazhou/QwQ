/// Represents the protocol any queue storage syncing delegates need to conform to.
protocol QueueStorageSyncDelegate: AnyObject {
    func customerDidJoinQueue(with record: QueueRecord)
    func customerDidUpdateQueueRecord(to new: QueueRecord)
    func customerDidWithdrawQueue(record: QueueRecord)

    func restaurantDidAdmitCustomer(record: QueueRecord)
    func restaurantDidServeCustomer(record: QueueRecord)
    // Supposing restaurant can only kick customers from waiting list and not the queue itself
    func restaurantDidRejectCustomer(record: QueueRecord)

    func restaurantDidPossiblyChangeQueueStatus(restaurant: Restaurant)
}

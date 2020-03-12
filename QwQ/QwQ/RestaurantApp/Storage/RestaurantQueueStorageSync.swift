protocol RestaurantQueueStorageSyncDelegate: AnyObject {
    func customerDidJoinQueue(with record: RestaurantQueueRecord)
    func customerDidUpdateQueueRecord(from old: RestaurantQueueRecord, to new: RestaurantQueueRecord)
    func customerDidWithdrawQueue(record: RestaurantQueueRecord)
    
    // if we allow restaurants to reject customers
    func restaurantDidRemoveQueueRecord(record: RestaurantQueueRecord)

    func restaurantDidAdmitCustomer(record: RestaurantQueueRecord)
    func restaurantDidServeCustomer(record: RestaurantQueueRecord)
    func restaurantDidRejectCustomer(record: RestaurantQueueRecord)
}

protocol RestaurantQueueStorageSync {
    var logicDelegate: RestaurantQueueStorageSyncDelegate? { get set }

    // MARK: - Sync handlers
    func didDetectNewQueueRecord(record: RestaurantQueueRecord)
    func didDetectUpdateOfQueueRecord(old: RestaurantQueueRecord, new: RestaurantQueueRecord)
    func didDetectDeletedQueueRecord(record: RestaurantQueueRecord)

    func didDetectAdmissionOfCustomer(record: RestaurantQueueRecord)

    func didOpenQueue(restaurant: Restaurant)
    func didCloseQueue(restaurant: Restaurant)

}

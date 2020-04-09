import Foundation

protocol QueueStorageSync {

    // MARK: - Listeners
    func registerListeners(for restaurant: Restaurant)

    func removeListeners()

    // MARK: - Delegates
    var logicDelegates: NSHashTable<AnyObject> { get }

    func registerDelegate(_ del: QueueStorageSyncDelegate)

    func unregisterDelegate(_ del: QueueStorageSyncDelegate)

}

protocol RestaurantQueueStorage: QueueStorageSync {
    // MARK: - Modifier
    func updateRestaurant(old: Restaurant, new: Restaurant)

    func updateRecord(oldRecord: QueueRecord, newRecord: QueueRecord,
                      completion: @escaping () -> Void)
}

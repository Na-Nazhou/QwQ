import Foundation

protocol QueueStorageSync {

    // MARK: - Listeners
    func registerListener(for restaurant: Restaurant)

    func removeListener()

    // MARK: - Delegates
    var logicDelegates: NSHashTable<AnyObject> { get }

    func registerDelegate(_ del: QueueStorageSyncDelegate)

    func unregisterDelegate(_ del: QueueStorageSyncDelegate)

}

protocol RestaurantQueueStorage: QueueStorageSync {
    // MARK: - Modifier
    func updateRecord(oldRecord: QueueRecord, newRecord: QueueRecord,
                      completion: @escaping () -> Void)

    func updateRecords(newRecords: [QueueRecord], completion: @escaping () -> Void)
}

import Foundation

protocol BookingStorageSync {
    var logicDelegates: NSHashTable<AnyObject> { get }
    
    func registerDelegate(_ del: BookingStorageSyncDelegate)
    func unregisterDelegate(_ del: BookingStorageSyncDelegate)

    func registerListener(for restaurant: Restaurant)
    func removeListener()
}

protocol RestaurantBookingStorage: BookingStorageSync {
    func updateRecord(oldRecord: BookRecord, newRecord: BookRecord,
                      completion: @escaping () -> Void)
}

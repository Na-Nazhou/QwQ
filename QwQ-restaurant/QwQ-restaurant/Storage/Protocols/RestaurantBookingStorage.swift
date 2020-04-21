import Foundation

protocol BookingStorageSync {

    // MARK: - Listeners
    func registerListener(for restaurant: Restaurant)

    func removeListener()

    // MARK: - Delegates
    func registerDelegate(_ del: BookingStorageSyncDelegate)

    func unregisterDelegate(_ del: BookingStorageSyncDelegate)

}

protocol RestaurantBookingStorage: BookingStorageSync {
    // MARK: - Modifiers
    func updateRecord(oldRecord: BookRecord, newRecord: BookRecord,
                      completion: @escaping () -> Void)

    func updateRecords(newRecords: [BookRecord], completion: @escaping () -> Void)
}

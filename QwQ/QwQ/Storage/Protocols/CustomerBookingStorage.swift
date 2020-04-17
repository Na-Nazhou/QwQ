import Foundation

protocol BookingStorageSync {

    // MARK: - Listeners
    func registerListener(for customer: Customer)

    func removeListener()

    // MARK: - Delegates
    var logicDelegates: NSHashTable<AnyObject> { get }

    func registerDelegate(_ del: BookingStorageSyncDelegate)

    func unregisterDelegate(_ del: BookingStorageSyncDelegate)
}

protocol CustomerBookingStorage: BookingStorageSync {
    // MARK: - Modifiers

    /// Insert multiple book records
    func addBookRecords(newRecords: [BookRecord], completion: @escaping () -> Void)

    /// Update a book record
    func updateBookRecord(oldRecord: BookRecord, newRecord: BookRecord,
                          completion: @escaping () -> Void)

    /// Update multiple book records
    func updateBookRecords(newRecords: [BookRecord], completion: @escaping () -> Void)
}

import Foundation

/// Represents the univeral booking storage sync protocol.
protocol BookingStorageSync {
    var logicDelegates: NSHashTable<AnyObject> { get }

    func registerDelegate(_ del: BookingStorageSyncDelegate)

    func unregisterDelegate(_ del: BookingStorageSyncDelegate)

    // MARK: - Listeners
    func registerListener(for customer: Customer)

    func removeListener()
}

protocol CustomerBookingStorage: BookingStorageSync {
    // MARK: - Modifier
    /// Insert a book record
    func addBookRecord(newRecord: BookRecord, completion: @escaping () -> Void)

    /// Update a book record (can only update groupSize, babyCount, wheelchairCount, and arrival time)
    func updateBookRecord(oldRecord: BookRecord, newRecord: BookRecord, completion: @escaping () -> Void)

    // MARK: - Query
    func loadActiveBookRecords(customer: Customer, completion: @escaping (BookRecord?) -> Void)

    func loadBookHistory(customer: Customer, completion: @escaping (BookRecord?) -> Void)

}

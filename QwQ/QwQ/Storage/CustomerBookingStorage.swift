import Foundation

protocol BookingStorageSync {
    var logicDelegates: NSHashTable<AnyObject> { get }

    func registerDelegate(_ del: BookingStorageSyncDelegate)

    func unregisterDelegate(_ del: BookingStorageSyncDelegate)

    // MARK: - Listeners
    func registerListener(for record: BookRecord)

    func removeListener(for record: BookRecord)
}

protocol CustomerBookingStorage: BookingStorageSync {
     // MARK: - Modifier
    /// Insert a book record
    func addBookRecord(newRecord: BookRecord, completion: @escaping (_ id: String) -> Void)

    /// Update a book record (can only update groupSize, babyCount, wheelchairCount, and arrival time)
    func updateBookRecord(oldRecord: BookRecord, newRecord: BookRecord, completion:  @escaping () -> Void)

    /// Delete a book record
    func deleteBookRecord(record: BookRecord, completion:  @escaping () -> Void)

    // MARK: - Query
    func loadActiveBookRecords(customer: Customer, completion: @escaping (BookRecord?) -> Void)

    func loadBookHistory(customer: Customer, completion: @escaping (BookRecord?) -> Void)

}

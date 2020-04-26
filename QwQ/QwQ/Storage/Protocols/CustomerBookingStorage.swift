/// Represents the protocol a synchronizable storage component should conform to for bookings.
protocol BookingStorageSync {

    // MARK: - Listeners
    /// Register to listen to all queue records of `customer`.
    func registerListener(for customer: Customer)

    /// Removes any registered listener.
    func removeListener()

    // MARK: - Delegates
    /// Register `del` as a delegate of this component.
    func registerDelegate(_ del: BookingStorageSyncDelegate)

     /// Unregister `del` from this component.
    func unregisterDelegate(_ del: BookingStorageSyncDelegate)
}

/// Represents the protocol a customer booking storage component should conform to.
protocol CustomerBookingStorage: BookingStorageSync {
    // MARK: - Modifiers
    /// Inserts multiple book records to the collection of booking records.
    func addBookRecords(newRecords: [BookRecord], completion: @escaping () -> Void)

    /// Updates a book record in collection from `oldRecord` to `newRecord`.
    func updateBookRecord(oldRecord: BookRecord, newRecord: BookRecord,
                          completion: @escaping () -> Void)

    /// Updates multiple book records to the records in `newRecords`.
    func updateBookRecords(newRecords: [BookRecord], completion: @escaping () -> Void)
}

/// Represents the protocol a synchronizable storage component should conform to for bookings.
protocol BookingStorageSync {

    // MARK: - Listeners
    /// Register to listen to all queue records of `restaurant`.
    func registerListener(for restaurant: Restaurant)
    
    /// Removes any registered listener.
    func removeListener()

    // MARK: - Delegates
    /// Register `del` as a delegate of this component.
    func registerDelegate(_ del: BookingStorageSyncDelegate)

    /// Unregister `del` from this component.
    func unregisterDelegate(_ del: BookingStorageSyncDelegate)

}

/// Represents the protocol a restaurant booking storage component should conform to.
protocol RestaurantBookingStorage: BookingStorageSync {
    // MARK: - Modifiers
    /// Updates a book record in collection from `oldRecord` to `newRecord`.
    func updateRecord(oldRecord: BookRecord, newRecord: BookRecord,
                      completion: @escaping () -> Void)
    
    /// Updates multiple book records to the records in `newRecords`.
    func updateRecords(newRecords: [BookRecord], completion: @escaping () -> Void)
}

//
//  CustomerBookingStorage.swift
//  QwQ
//
//  Created by Nazhou Na on 19/3/20.
//

protocol BookingStorageSync {
    var logicDelegate: BookingStorageSyncDelegate? { get set }
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

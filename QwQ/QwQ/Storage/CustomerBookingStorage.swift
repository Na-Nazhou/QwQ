//
//  CustomerBookingStorage.swift
//  QwQ
//
//  Created by Nazhou Na on 19/3/20.
//

protocol CustomerBookingStorage: BookingStorageSync {
    /// Insert a book record
     func addBookRecord(record: BookRecord, completion: @escaping (String) -> Void)
     /// Update a book record (can only update groupSize, babyCount, wheelchairCount, and arrival time)
     func updateBookRecord(old: BookRecord, new: BookRecord, completion:  @escaping () -> Void)
     /// Delete a book record
     func deleteBookRecord(record: BookRecord, completion:  @escaping () -> Void)

     // MARK: - Query
     func loadActiveBookRecords(customer: Customer, completion: @escaping ([BookRecord]) -> Void)

     func loadBookHistory(customer: Customer, completion: @escaping ([BookRecord]) -> Void)
}

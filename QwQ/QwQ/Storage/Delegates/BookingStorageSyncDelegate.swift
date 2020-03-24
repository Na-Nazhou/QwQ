//
//  CustomerBookingStorageSync.swift
//  QwQ
//
//  Created by Nazhou Na on 19/3/20.
//

protocol BookingStorageSyncDelegate: AnyObject {

    func didDeleteBookRecord(_ record: BookRecord)

    func didUpdateBookRecord(_ record: BookRecord)

    // Customer actions synced from other devices -- TODO?
    //    func didAddBookRecord(newRecord: BookRecord)
}

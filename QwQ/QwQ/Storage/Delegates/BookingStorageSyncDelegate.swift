//
//  CustomerBookingStorageSync.swift
//  QwQ
//
//  Created by Nazhou Na on 19/3/20.
//

protocol BookingStorageSyncDelegate: AnyObject {

    func didDeleteActiveBookRecord(_ record: BookRecord)

    func didUpdateBookRecord(_ record: BookRecord)
}

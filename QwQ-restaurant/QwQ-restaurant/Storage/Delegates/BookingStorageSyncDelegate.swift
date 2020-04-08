//
//  BookingStorageSyncDelegate.swift
//  QwQ-restaurant
//
//  Created by Nazhou Na on 25/3/20.
//

protocol BookingStorageSyncDelegate: AnyObject {

    func didAddBookRecord(_ record: BookRecord)

    func didUpdateBookRecord(_ record: BookRecord)

}

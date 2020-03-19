//
//  CustomerBookingLogic.swift
//  QwQ
//
//  Created by Nazhou Na on 19/3/20.
//

protocol CustomerBookingLogic: BookingStorageSyncDelegate {

    // Storage
    var bookingStorage: CustomerBookingStorage { get set }

    // View Controllers
    var bookingDelegate: BookingDelegate? { get set }
}

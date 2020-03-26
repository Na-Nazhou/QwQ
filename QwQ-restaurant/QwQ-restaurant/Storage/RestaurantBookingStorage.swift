//
//  RestaurantBookingStorage.swift
//  QwQ-restaurant
//
//  Created by Nazhou Na on 25/3/20.
//

protocol BookingStorageSync {

    var logicDelegate: BookingStorageSyncDelegate? { get set }

}

protocol RestaurantBookingStorage: BookingStorageSync {
    
}

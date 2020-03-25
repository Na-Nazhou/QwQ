//
//  FBBookingStorage.swift
//  QwQ-restaurant
//
//  Created by Nazhou Na on 25/3/20.
//

import FirebaseFirestore
import Foundation

class FBBookingStorage: RestaurantBookingStorage {

    let db = Firestore.firestore()

    weak var logicDelegate: BookingStorageSyncDelegate?

}

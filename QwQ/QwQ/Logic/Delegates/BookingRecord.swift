//
//  BookingRecord.swift
//  QwQ
//
//  Created by Nazhou Na on 16/3/20.
//

import Foundation

struct BookingRecord {
    let restaurant: Restaurant
    let customer: Customer

    var groupSize: Int
    var babyChairQuantity: Int
    var wheelchairFriendly: Bool

    let time: Date
}

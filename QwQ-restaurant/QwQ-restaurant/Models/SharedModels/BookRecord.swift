//
//  BookRecord.swift
//  QwQ
//
//  Created by Nazhou Na on 16/3/20.
//

import Foundation

struct BookRecord: Record {
    let id: String
    let restaurant: Restaurant
    let customer: Customer

    var groupSize: Int
    var babyChairQuantity: Int
    var wheelchairFriendly: Bool

    let time: Date
    var admitTime: Date?
    var rejectTime: Date?

    var isHistoryRecord: Bool {
        admitTime != nil || rejectTime != nil
    }
}

//
//  BookRecord.swift
//  QwQ
//
//  Created by Nazhou Na on 16/3/20.
//

import Foundation

struct BookRecord: Record {
    var id = "0"
    let restaurant: Restaurant
    let customer: Customer

    let groupSize: Int
    let babyChairQuantity: Int
    let wheelchairFriendly: Bool

    let time: Date

    var date: String {
        time.toDateStringWithoutTime()
    }

    var formattedTime: String {
        time.toString()
    }

    let admitTime: Date?
    let serveTime: Date?
    let rejectTime: Date?

    var isHistoryRecord: Bool {
        admitTime != nil || rejectTime != nil
    }

    init(restaurant: Restaurant, customer: Customer, time: Date,
         groupSize: Int, babyChairQuantity: Int, wheelchairFriendly: Bool,
         admitTime: Date? = nil, serveTime: Date? = nil, rejectTime: Date? = nil) {
        self.init(id: "0", restaurant: restaurant, customer: customer, time: time,
                  groupSize: groupSize, babyChairQuantity: babyChairQuantity,
                  wheelchairFriendly: wheelchairFriendly,
                  admitTime: admitTime, serveTime: serveTime, rejectTime: rejectTime)
    }

    init(id: String, restaurant: Restaurant, customer: Customer, time: Date,
         groupSize: Int, babyChairQuantity: Int, wheelchairFriendly: Bool,
         admitTime: Date? = nil, serveTime: Date? = nil, rejectTime: Date? = nil) {
        self.id = id
        self.restaurant = restaurant
        self.customer = customer
        self.groupSize = groupSize
        self.babyChairQuantity = babyChairQuantity
        self.wheelchairFriendly = wheelchairFriendly
        self.time = time

        self.admitTime = admitTime
        self.serveTime = serveTime
        self.rejectTime = rejectTime
    }
}

extension BookRecord: Hashable {
    static func == (lhs: BookRecord, rhs: BookRecord) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension BookRecord {
    var dictionary: [String: Any] {
        var data = [String: Any]()
        data["customer"] = customer.uid
        data["groupSize"] = groupSize
        data["babyChairQuantity"] = babyChairQuantity
        data["wheelchairFriendly"] = wheelchairFriendly
        data["time"] = time

        if let admitTime = admitTime {
            data["admitTime"] = admitTime
        }
        if let serveTime = serveTime {
            data["serveTime"] = serveTime
        }
        if let rejectTime = rejectTime {
            data["rejectTime"] = rejectTime
        }

        return data
    }
}

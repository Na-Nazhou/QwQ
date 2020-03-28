//
//  BookRecord.swift
//  QwQ
//
//  Created by Nazhou Na on 16/3/20.
//

import Foundation
import FirebaseFirestore

struct BookRecord: Record {
    var id: String
    let restaurant: Restaurant
    let customer: Customer

    let groupSize: Int
    let babyChairQuantity: Int
    let wheelchairFriendly: Bool

    let time: Date

    var date: String {
        Date.getFormattedDate(date: time, format: Constants.recordDateFormat)
    }

    let admitTime: Date?
    let serveTime: Date?
    let rejectTime: Date?
    var withdrawTime: Date?

    var dictionary: [String: Any] {
        var data = [String: Any]()
        data["restaurant"] = restaurant.uid
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
        if let withdrawTime = withdrawTime {
            data["withdrawTime"] = withdrawTime
        }

        return data
    }

    init(restaurant: Restaurant, customer: Customer, time: Date,
         groupSize: Int, babyChairQuantity: Int, wheelchairFriendly: Bool,
         admitTime: Date? = nil, serveTime: Date? = nil,
         rejectTime: Date? = nil, withdrawTime: Date? = nil) {
        self.init(id: "0", restaurant: restaurant, customer: customer, time: time,
                  groupSize: groupSize, babyChairQuantity: babyChairQuantity,
                  wheelchairFriendly: wheelchairFriendly,
                  admitTime: admitTime, serveTime: serveTime,
                  rejectTime: rejectTime, withdrawTime: withdrawTime)
    }

    init(id: String, restaurant: Restaurant, customer: Customer, time: Date,
         groupSize: Int, babyChairQuantity: Int, wheelchairFriendly: Bool,
         admitTime: Date? = nil, serveTime: Date? = nil,
         rejectTime: Date? = nil, withdrawTime: Date? = nil) {
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
        self.withdrawTime = withdrawTime
    }

    init?(dictionary: [String: Any], customer: Customer, restaurant: Restaurant, id: String) {
        guard let groupSize = dictionary["groupSize"] as? Int,
            let babyChairQuantity = dictionary["babyChairQuantity"] as? Int,
            let wheelchairFriendly = dictionary["wheelchairFriendly"] as? Bool,
            let time = (dictionary["time"] as? Timestamp)?.dateValue() else {
                return nil
        }
        let admitTime = (dictionary["admitTime"] as? Timestamp)?.dateValue()
        let serveTime = (dictionary["serveTime"] as? Timestamp)?.dateValue()
        let rejectTime = (dictionary["rejectTime"] as? Timestamp)?.dateValue()
        let withdrawTime = (dictionary["withdrawTime"] as? Timestamp)?.dateValue()

        self.init(id: id, restaurant: restaurant, customer: customer,
                  time: time,
                  groupSize: groupSize,
                  babyChairQuantity: babyChairQuantity,
                  wheelchairFriendly: wheelchairFriendly,
                  admitTime: admitTime, serveTime: serveTime,
                  rejectTime: rejectTime)
    }
}

extension BookRecord: Hashable {
    static func == (lhs: BookRecord, rhs: BookRecord) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    func completelyIdentical(to other: BookRecord) -> Bool {
        other == self
            && other.restaurant == restaurant
            && other.customer == customer
            && other.time == time
            && other.groupSize == groupSize
            && other.babyChairQuantity == babyChairQuantity
            && other.wheelchairFriendly == wheelchairFriendly
            && other.admitTime == admitTime
            && other.serveTime == serveTime
            && other.rejectTime == rejectTime
            && other.withdrawTime == withdrawTime
    }
}

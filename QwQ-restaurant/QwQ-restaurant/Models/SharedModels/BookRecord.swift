//
//  BookRecord.swift
//  QwQ
//
//  Created by Nazhou Na on 16/3/20.
//

import Foundation
import FirebaseFirestore

struct BookRecord: Record {
    let id: String
    let restaurant: Restaurant
    let customer: Customer

    let groupSize: Int
    let babyChairQuantity: Int
    let wheelchairFriendly: Bool

    let time: Date

    var date: String {
        Date.getFormattedDate(date: time, format: Constants.recordDateFormat)
    }

    var admitTime: Date?
    var serveTime: Date?
    var rejectTime: Date?
    let withdrawTime: Date?
    var confirmAdmissionTime: Date? {
        admitTime   // for bookings, the first admitted one will be auto accepted, the rest withdrawn.
    }
    var missTime: Date? = nil
    var readmitTime: Date? = nil

    var autoRejectTimer: Timer?

    var dictionary: [String: Any] {
        var data = [String: Any]()
        data[Constants.restaurantKey] = restaurant.uid
        data[Constants.customerKey] = customer.uid
        data[Constants.groupSizeKey] = groupSize
        data[Constants.babyChairQuantityKey] = babyChairQuantity
        data[Constants.wheelChairFriendlyKey] = wheelchairFriendly
        data[Constants.timeKey] = time

        if let admitTime = admitTime {
            data[Constants.admitTimeKey] = admitTime
        }
        if let serveTime = serveTime {
            data[Constants.serveTimeKey] = serveTime
        }
        if let rejectTime = rejectTime {
            data[Constants.rejectTimeKey] = rejectTime
        }
        if let withdrawTime = withdrawTime {
            data[Constants.withdrawTimeKey] = withdrawTime
        }
        if let missTime = missTime {
            data[Constants.missTimeKey] = missTime
        }

        return data
    }

    init(id: String, restaurant: Restaurant, customer: Customer, time: Date,
         groupSize: Int, babyChairQuantity: Int, wheelchairFriendly: Bool,
         admitTime: Date? = nil, serveTime: Date? = nil,
         rejectTime: Date? = nil, withdrawTime: Date? = nil,
         missTime: Date? = nil) {
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
        self.missTime = missTime
    }

    init?(dictionary: [String: Any], customer: Customer, restaurant: Restaurant, id: String) {
        guard let groupSize = dictionary[Constants.groupSizeKey] as? Int,
            let babyChairQuantity = dictionary[Constants.babyChairQuantityKey] as? Int,
            let wheelchairFriendly = dictionary[Constants.wheelChairFriendlyKey] as? Bool,
            let time = (dictionary[Constants.timeKey] as? Timestamp)?.dateValue() else {
                return nil
        }
        let admitTime = (dictionary[Constants.admitTimeKey] as? Timestamp)?.dateValue()
        let serveTime = (dictionary[Constants.serveTimeKey] as? Timestamp)?.dateValue()
        let rejectTime = (dictionary[Constants.rejectTimeKey] as? Timestamp)?.dateValue()
        let withdrawTime = (dictionary[Constants.withdrawTimeKey] as? Timestamp)?.dateValue()
        let missTime = (dictionary[Constants.missTimeKey] as? Timestamp)?.dateValue()

        self.init(id: id, restaurant: restaurant, customer: customer,
                  time: time,
                  groupSize: groupSize,
                  babyChairQuantity: babyChairQuantity,
                  wheelchairFriendly: wheelchairFriendly,
                  admitTime: admitTime, serveTime: serveTime,
                  rejectTime: rejectTime, withdrawTime: withdrawTime,
                  missTime: missTime)
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

extension BookRecord {
    var status: RecordStatus {
        if withdrawTime != nil {
            return .withdrawn
        } else if rejectTime != nil {
            return .rejected
        } else if admitTime != nil && serveTime != nil {
            return .served
        } else if admitTime != nil && confirmAdmissionTime != nil {
            return .confirmedAdmission
        } else if admitTime != nil {
            return .admitted
        } else if admitTime == nil && rejectTime == nil && serveTime == nil {
            return .pendingAdmission
        }
        return .invalid
    }

    func getChangeType(from old: Record) -> RecordModification? {
        if self.id != old.id {
            // not valid comparison
            return nil
        }

        if old.status == self.status {
            return .customerUpdate
        }

        if status == .withdrawn {
            return .withdraw
        }

        if old.status == .pendingAdmission && self.status == .confirmedAdmission {
            return .confirmAdmission
        }

        if old.status == .pendingAdmission && self.status == .rejected {
            return .reject
        }

        if old.status == .confirmedAdmission && self.status == .served {
            return .serve
        }

        return nil
    }
}

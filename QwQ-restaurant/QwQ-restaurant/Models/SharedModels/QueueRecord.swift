import Foundation
import FirebaseFirestore

struct QueueRecord: Record {
    let id: String
    let restaurant: Restaurant
    let customer: Customer

    let groupSize: Int
    let babyChairQuantity: Int
    let wheelchairFriendly: Bool

    let startTime: Date

    var admitTime: Date?
    var serveTime: Date?
    var rejectTime: Date?
    let withdrawTime: Date?
    let confirmAdmissionTime: Date?
    var estimatedAdmitTime: Date?

    var startDate: String {
        Date.getFormattedDate(date: startTime, format: Constants.recordDateFormat)
    }

    var dictionary: [String: Any] {
        var data = [String: Any]()
        data[Constants.customerKey] = customer.uid
        data[Constants.groupSizeKey] = groupSize
        data[Constants.babyChairQuantityKey] = babyChairQuantity
        data[Constants.wheelChairFriendlyKey] = wheelchairFriendly
        data[Constants.startTimeKey] = startTime
        data[Constants.restaurantKey] = restaurant.uid

        if let estimatedAdmitTime = estimatedAdmitTime {
            data[Constants.estimatedAdmitTimeKey] = estimatedAdmitTime
        }
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
        if let confirmAdmissionTime = confirmAdmissionTime {
            data[Constants.confirmAdmissionTimeKey] = confirmAdmissionTime
        }

        return data
    }

    init(id: String, restaurant: Restaurant, customer: Customer,
         groupSize: Int, babyChairQuantity: Int, wheelchairFriendly: Bool,
         startTime: Date, admitTime: Date? = nil, serveTime: Date? = nil,
         rejectTime: Date? = nil, withdrawTime: Date? = nil,
         confirmAdmissionTime: Date? = nil, estimatedAdmitTime: Date? = nil) {
        self.id = id
        self.restaurant = restaurant
        self.customer = customer
        self.groupSize = groupSize
        self.babyChairQuantity = babyChairQuantity
        self.wheelchairFriendly = wheelchairFriendly
        self.startTime = startTime

        self.admitTime = admitTime
        self.serveTime = serveTime
        self.rejectTime = rejectTime
        self.withdrawTime = withdrawTime
        self.confirmAdmissionTime = confirmAdmissionTime
        self.estimatedAdmitTime = estimatedAdmitTime
    }

    init?(dictionary: [String: Any], customer: Customer, restaurant: Restaurant, id: String) {
        guard let groupSize = dictionary[Constants.groupSizeKey] as? Int,
            let babyChairQuantity = dictionary[Constants.babyChairQuantityKey] as? Int,
            let wheelchairFriendly = dictionary[Constants.wheelChairFriendlyKey] as? Bool,
            let startTime = (dictionary[Constants.startTimeKey] as? Timestamp)?.dateValue() else {
                return nil
        }
        let admitTime = (dictionary[Constants.admitTimeKey] as? Timestamp)?.dateValue()
        let serveTime = (dictionary[Constants.serveTimeKey] as? Timestamp)?.dateValue()
        let rejectTime = (dictionary[Constants.rejectTimeKey] as? Timestamp)?.dateValue()
        let withdrawTime = (dictionary[Constants.withdrawTimeKey] as? Timestamp)?.dateValue()
        let confirmAdmissionTime = (dictionary[Constants.confirmAdmissionTimeKey] as? Timestamp)?.dateValue()
        let estimatedAdmitTime = (dictionary[Constants.estimatedAdmitTimeKey] as? Timestamp)?.dateValue()

        self.init(id: id, restaurant: restaurant, customer: customer,
                  groupSize: groupSize, babyChairQuantity: babyChairQuantity,
                  wheelchairFriendly: wheelchairFriendly,
                  startTime: startTime, admitTime: admitTime,
                  serveTime: serveTime, rejectTime: rejectTime, withdrawTime: withdrawTime,
                  confirmAdmissionTime: confirmAdmissionTime,
                  estimatedAdmitTime: estimatedAdmitTime)
    }
}

extension QueueRecord: Hashable {
    static func == (lhs: QueueRecord, rhs: QueueRecord) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension QueueRecord {
    func completelyIdentical(to other: QueueRecord) -> Bool {
        other == self
            && other.restaurant == restaurant
            && other.customer == customer
            && other.startTime == startTime
            && other.groupSize == groupSize
            && other.babyChairQuantity == babyChairQuantity
            && other.wheelchairFriendly == wheelchairFriendly
            && other.admitTime == admitTime
            && other.serveTime == serveTime
            && other.rejectTime == rejectTime
            && other.withdrawTime == withdrawTime
            && other.confirmAdmissionTime == confirmAdmissionTime
            && other.estimatedAdmitTime == estimatedAdmitTime
    }
}

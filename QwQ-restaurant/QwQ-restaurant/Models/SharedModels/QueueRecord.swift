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

    var startDate: String {
        Date.getFormattedDate(date: startTime, format: Constants.recordDateFormat)
    }

    var dictionary: [String: Any] {
        var data = [String: Any]()
        data["customer"] = customer.uid
        data["groupSize"] = groupSize
        data["babyChairQuantity"] = babyChairQuantity
        data["wheelchairFriendly"] = wheelchairFriendly
        data["startTime"] = startTime

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

    init(id: String, restaurant: Restaurant, customer: Customer,
         groupSize: Int, babyChairQuantity: Int, wheelchairFriendly: Bool,
         startTime: Date, admitTime: Date? = nil, serveTime: Date? = nil, rejectTime: Date? = nil, withdrawTime: Date? = nil) {
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
    }

    init?(dictionary: [String: Any], customer: Customer, restaurant: Restaurant, id: String) {
        guard let groupSize = dictionary["groupSize"] as? Int,
            let babyChairQuantity = dictionary["babyChairQuantity"] as? Int,
            let wheelchairFriendly = dictionary["wheelchairFriendly"] as? Bool,
            let startTime = (dictionary["startTime"] as? Timestamp)?.dateValue() else {
                return nil
        }
        let admitTime = (dictionary["admitTime"] as? Timestamp)?.dateValue()
        let serveTime = (dictionary["serveTime"] as? Timestamp)?.dateValue()
        let rejectTime = (dictionary["rejectTime"] as? Timestamp)?.dateValue()
        let withdrawTime = (dictionary["withdrawTime"] as? Timestamp)?.dateValue()

        self.init(id: id, restaurant: restaurant, customer: customer,
                  groupSize: groupSize, babyChairQuantity: babyChairQuantity,
                  wheelchairFriendly: wheelchairFriendly,
                  startTime: startTime, admitTime: admitTime,
                  serveTime: serveTime, rejectTime: rejectTime, withdrawTime: withdrawTime)
    }

}

extension QueueRecord: Hashable {
    static func == (lhs: QueueRecord, rhs: QueueRecord) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

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
    }
}

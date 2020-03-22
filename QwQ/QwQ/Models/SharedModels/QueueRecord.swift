import Foundation
import FirebaseFirestore

struct QueueRecord: Record {
    var id = "0"
    let restaurant: Restaurant
    let customer: Customer

    let groupSize: Int
    let babyChairQuantity: Int
    let wheelchairFriendly: Bool

    let startTime: Date
    var admitTime: Date?
    var serveTime: Date?
    var rejectTime: Date?

    var startDate: String {
        startTime.toDateStringWithoutTime()
    }

    init(restaurant: Restaurant, customer: Customer,
         groupSize: Int, babyChairQuantity: Int, wheelchairFriendly: Bool,
         startTime: Date, admitTime: Date? = nil, serveTime: Date? = nil, rejectTime: Date? = nil) {
        self.init(id: "0", restaurant: restaurant, customer: customer,
                  groupSize: groupSize, babyChairQuantity: babyChairQuantity,
                  wheelchairFriendly: wheelchairFriendly,
                  startTime: startTime, admitTime: admitTime,
                  serveTime: serveTime, rejectTime: rejectTime)
    }

    init(id: String, restaurant: Restaurant, customer: Customer,
         groupSize: Int, babyChairQuantity: Int, wheelchairFriendly: Bool,
         startTime: Date, admitTime: Date? = nil, serveTime: Date? = nil, rejectTime: Date? = nil) {
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
    }

    init?(dictionary: [String: Any], customer: Customer, restaurant: Restaurant, id: String = "0") {
        guard let groupSize = dictionary["groupSize"] as? Int,
            let babyChairQuantity = dictionary["babyChairQuantity"] as? Int,
            let wheelchairFriendly = dictionary["wheelchairFriendly"] as? Bool,
            let startTime = (dictionary["startTime"] as? Timestamp)?.dateValue() else {
                return nil
        }
        let admitTime = (dictionary["admitTime"] as? Timestamp)?.dateValue()
        let serveTime = (dictionary["serveTime"] as? Timestamp)?.dateValue()
        let rejectTime = (dictionary["rejectTime"] as? Timestamp)?.dateValue()
        
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
    }

}

extension QueueRecord: Hashable {
    static func == (lhs: QueueRecord, rhs: QueueRecord) -> Bool {
        lhs.restaurant == rhs.restaurant
            && lhs.customer == rhs.customer
            && lhs.startTime == rhs.startTime
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(self.restaurant)
        hasher.combine(self.customer)
        hasher.combine(self.startTime)
    }
}

extension QueueRecord {
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

        return data
    }

    var isHistoryRecord: Bool {
        serveTime != nil || rejectTime != nil
    }
    
    var isWaitingRecord: Bool {
        serveTime == nil && admitTime != nil
    }

    var isUnadmittedQueueingRecord: Bool {
        admitTime == nil
    }

    func completelyIdentical(to other: QueueRecord) -> Bool {
        other == self
            && other.groupSize == groupSize
            && other.babyChairQuantity == babyChairQuantity
            && other.wheelchairFriendly == wheelchairFriendly
            && other.admitTime == admitTime
            && other.serveTime == serveTime
            && other.rejectTime == rejectTime
    }
}

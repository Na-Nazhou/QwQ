import Foundation
import FirebaseFirestore

struct QueueRecord: Record {
    var id = "0"
    let restaurant: Restaurant
    let customer: Customer

    var groupSize: Int
    var babyChairQuantity: Int
    var wheelchairFriendly: Bool

    let startTime: Date
    var admitTime: Date?
    var serveTime: Date?
    var rejectTime: Date?

    var startDate: String {
        startTime.toDateStringWithoutTime()
    }

    init(restaurant: Restaurant, customer: Customer, groupSize: Int, babyChairQuantity: Int, wheelchairFriendly: Bool,
         startTime: Date, admitTime: Date? = nil, serveTime: Date? = nil, rejectTime: Date? = nil) {
        self.init(id: "0", restaurant: restaurant, customer: customer,
                  groupSize: groupSize, babyChairQuantity: babyChairQuantity, wheelchairFriendly: wheelchairFriendly,
                  startTime: startTime, admitTime: admitTime, serveTime: serveTime, rejectTime: rejectTime)
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
            let babyCQuantity = dictionary["babyChairQuantity"] as? Int,
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
        self.babyChairQuantity = babyCQuantity
        self.wheelchairFriendly = wheelchairFriendly
        self.startTime = startTime
        self.admitTime = admitTime
        self.serveTime = serveTime
        self.rejectTime = rejectTime
    }

}

extension QueueRecord: Hashable {
    static func == (lhs: QueueRecord, rhs: QueueRecord) -> Bool {
        return lhs.restaurant == rhs.restaurant
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
    static func queueRecordToDictionary(_ record: QueueRecord) -> [String: Any] {
        var data = [String: Any]()
        data["customer"] = record.customer.uid
        data["groupSize"] = record.groupSize
        data["babyChairQuantity"] = record.babyChairQuantity
        data["wheelchairFriendly"] = record.wheelchairFriendly
        data["startTime"] = record.startTime

        if let admitTime = record.admitTime {
            data["admitTime"] = admitTime
        }
        if let serveTime = record.serveTime {
            data["serveTime"] = serveTime
        }
        if let rejectTime = record.rejectTime {
            data["rejectTime"] = rejectTime
        }

        return data
    }

    var isHistoryRecord: Bool {
        serveTime != nil || rejectTime != nil
    }
    
    var isWaitingRecord: Bool {
        serveTime == nil && admitTime != nil && rejectTime == nil
    }

    var isUnadmittedQueueingRecord: Bool {
        admitTime == nil
    }

    func completelyIdentical(to other: QueueRecord) -> Bool {
        return other == self
            && other.groupSize == groupSize
            && other.babyChairQuantity == babyChairQuantity
            && other.wheelchairFriendly == wheelchairFriendly
            && other.admitTime == admitTime
            && other.serveTime == serveTime
            && other.rejectTime == rejectTime
    }
}

extension QueueRecord {
    func changeType(from old: QueueRecord) -> QueueRecordModificationType? {
        if self.id != old.id {
            // not valid comparison
            return nil
        }

        if self.admitTime != nil {
            if old.admitTime == nil {
                return .admit
            }
            if self.serveTime != nil {
                return .serve
            }
            if self.rejectTime != nil {
                return .reject
            }
            assert(false, "No valid modification detected: Customer update should not be allowed after admission.")
        }
        return .customerUpdate
    }
}

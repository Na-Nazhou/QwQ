import Foundation
import FirebaseFirestore

struct QueueRecord {
    let id: String
    let restaurant: Restaurant
    let customer: Customer

    var groupSize: Int
    var babyChairQuantity: Int
    var wheelchairFriendly: Bool

    let startTime: Date
    var admitTime: Date?
    var serveTime: Date?
    var rejectTime: Date?

    init?(dictionary: [String: Any]) {
        guard let id = dictionary["id"] as? String,
            let rId = dictionary["restaurant"] as? String,
            let cId = dictionary["customer"] as? String,
            let groupSize = dictionary["groupSize"] as? Int,
            let babyCQuantity = dictionary["babyChairQuantity"] as? Int,
            let wheelchairFriendly = dictionary["wheelchairFriendly"] as? Bool,
            let startTime = (dictionary["startTime"] as? TimeStamp)?.dateValue() else {
                return nil
        }
        //TODO - daniel: get R from uid of restaurant.
        var serveTime = (dictionary["serveTime"] as? TimeStamp)?.dateValue() ?? nil
        var rejectTime = (dictionary["rejectTime"] as? TimeStamp)?.dateValue() ?? nil
        
    }
}

extension QueueRecord {
    static func getDateString(from datetime: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "ddMMyyyy"
        return formatter.string(from: datetime)
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

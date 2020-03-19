import Foundation

struct QueueRecord: Hashable, Record {
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

    var isHistoryRecord: Bool {
        serveTime != nil || rejectTime != nil
    }

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

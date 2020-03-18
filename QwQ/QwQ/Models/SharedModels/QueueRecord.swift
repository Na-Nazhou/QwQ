import Foundation

struct QueueRecord: Record {
    var id = "0"
    let restaurant: Restaurant
    let customer: Customer

    var groupSize: Int
    var babyChairQuantity: Int
    var wheelchairFriendly: Bool

    let startTime: Date
    var admitTime: Date?
    var rejectTime: Date?

    var startDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "ddMMyyyy"
        return formatter.string(from: startTime)
    }

    var isHistoryRecord: Bool {
        admitTime != nil || rejectTime != nil
    }
}

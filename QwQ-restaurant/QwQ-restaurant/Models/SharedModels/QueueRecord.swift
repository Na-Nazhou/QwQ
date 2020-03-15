import Foundation

struct QueueRecord: Hashable {
    let restaurant: Restaurant
    let customer: Customer

    var groupSize: Int
    var babyCount: Int
    var wheelchairCount: Int

    let startTime: Date
    var admitTime: Date?
    var serveTime: Date?
    
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

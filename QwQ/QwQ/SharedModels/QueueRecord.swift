import Foundation

struct QueueRecord {
    let restaurant: Restaurant
    let customer: Customer

    var groupSize: Int
    var babyCount: Int
    var wheelchairCount: Int

    let startTime: Date
    var admitTime: Date?
    var serveTime: Date?
}

import Foundation

struct QueueRecord {
    let restaurant: Restaurant
    let customer: Customer

    let groupSize: Int
    let babyCount: Int
    let wheelchairCount: Int

    let startTime: Date
    let admitTime: Date?
    let serveTime: Date?
}

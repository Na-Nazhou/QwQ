import Foundation

struct RestaurantQueueRecord: QueueRecord {
    let customer: Customer

    let groupSize: Int
    let babyCount: Int
    let wheelchairCount: Int
    let startTime: Date
    let serveTime: Date?
}

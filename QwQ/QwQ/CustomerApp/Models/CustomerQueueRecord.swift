import Foundation

struct CustomerQueueRecord: QueueRecord {
    let restaurant: Restaurant

    let groupSize: Int
    let babyCount: Int
    let wheelchairCount: Int
    let startTime: Date
    let serveTime: Date?
}

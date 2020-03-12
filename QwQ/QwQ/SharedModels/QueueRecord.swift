import Foundation

protocol QueueRecord {
    var groupSize: Int { get }
    var babyCount: Int { get }
    var wheelchairCount: Int { get }

    /// Time when customer started to queue
    var startTime: Date { get }
    /// Time when restaurant allows customers in.
    var admitTime: Date { get }
    /// Time when customer turns up.
    var serveTime: Date? { get }
}

import Foundation

protocol QueueRecord {
    var groupSize: Int { get }
    var babyCount: Int { get }
    var wheelchairCount: Int { get }
    var startTime: Date { get }
    var serveTime: Date? { get }
}

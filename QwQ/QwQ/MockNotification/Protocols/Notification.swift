import Foundation

protocol Notification {
    var id: String { get }
    var timeScheduled: DateComponents { get }
    var title: String { get }
    var description: String { get }
    var shouldBeSentRegardlessOfTime: Bool { get }
}

import Foundation

/// Represents a notification with a unique `id` amongst pending notifications having `title` and `description`.
/// When scheduled, notification should trigger at `timeScheduled` if `timeScheduled` is in the future;
/// otherwise should trigger immediately if `shouldBeSentRegardlessOfTime` is `true`.
protocol Notification {
    var id: String { get }
    var timeScheduled: DateComponents { get }
    var title: String { get }
    var description: String { get }
    var shouldBeSentRegardlessOfTime: Bool { get }
}

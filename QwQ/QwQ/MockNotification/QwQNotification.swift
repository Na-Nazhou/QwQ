import Foundation

/// A QwQ notification structure. Each `QwQNotification` is identified by  `notifId`, which depends
/// on the scheduled trigger time and the related record.
struct QwQNotification: Notification {
    let notifId: QwQNotificationId
    let title: String
    let description: String
    let shouldBeSentRegardlessOfTime: Bool

    var timeScheduled: DateComponents {
        notifId.targetTime
    }
    var id: String {
        notifId.toString
    }
    
    /// Constructs a `QwQNotification` that triggers at the time specified by `notifId`.
    /// `shouldSend` should be set to `false` if this notification is outdated and should not trigger.
    /// Otherwise, `shouldSend` should be set to `true` so this notification will fire immediately if it is outdated.
    init(notifId: QwQNotificationId, title: String, description: String, shouldSend: Bool) {
        self.notifId = notifId
        self.title = title
        self.description = description
        shouldBeSentRegardlessOfTime = shouldSend
    }
}

import Foundation

struct QwQNotification: Notification {
    let notifId: QwQNotificationId
    let title: String
    let description: String
    let shouldBeSentRegardlessOfTime: Bool

    var timeScheduled: DateComponents {
        notifId.targetTime
    }
    var id: String {
        notifId.string
    }
    
    init(notifId: QwQNotificationId, title: String, description: String, shouldSend: Bool) {
        self.notifId = notifId
        self.title = title
        self.description = description
        shouldBeSentRegardlessOfTime = shouldSend
    }
}

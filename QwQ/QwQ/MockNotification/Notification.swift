import Foundation

struct Notification {
    var id: String /// For removing  pending notif
    var title: String
    var description: String
    //var datetime: DateComponents
    var timeInterval: Double
    
    fileprivate init(id: String, title: String, description: String, timeInterval: Double) {
        self.id = id
        self.title = title
        self.description = description
        self.timeInterval = timeInterval
    }
}

/// Specific to QwQ notifications.
class QwQNotificationGenerator: QwQNotifications {
    /// Sets 2 notifs: 1) accepted 2) schedule for booking time.
    func notifyBookingAcceptance() {
    }

    /// Sets 4 notifs: 1) admitted 2) 1min mark 3) 2min marl 3) 3min missed queue (pushed back)
    func notifyQueueAdmittance() {
        
    }

    func notifyBookingRejection() {
        
    }

    func notifyQueueRejection() {
        
    }

    func retrackNotifications(afterConfirmAdmitFor record: QueueRecord) {
        
    }
}

struct QwQNotificationId {
    let recordId: String
    let firstAdmittedTiming: Date
    let timeIntervalScheduled: Double
    
    var string: String {
        "\(recordId) at \(firstAdmittedTiming) with interval \(timeIntervalScheduled)"
    }
}

//struct NotificationType {
//    let action: RestaurantAction
//    let option:
//}

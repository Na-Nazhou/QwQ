import Foundation
import os.log

/// Specific to QwQ notifications.
class QwQNotificationGenerator: QwQNotifications {
    let notifManager = LocalNotificationManager()

    /// Sets 2 notifs: 1) accepted 2) schedule for booking time.
    func notifyBookingAcceptance(record: BookRecord) {
        guard let notifAcceptId = QwQNotificationId(record: record, timeInMinutesFromAdmittedTime: 0) else {
            os_log("Failed to send notification about booking acceptance.", log: Log.bookNotifError, type: .error)
            return
        }
        let notifAccept = Notification(
            notifId: notifAcceptId,
            title: "Booking Accepted by \(record.restaurant.name)",
            description: "You can now view your accepted booking in the Activities page!", shouldSend: true)
        notifManager.schedule(notif: notifAccept)
        os_log("Book acceptance notif sent to schedule.", log: Log.bookNotifScheduled, type: .info)

        guard let notifIdTimeToEnter = QwQNotificationId(record: record, targetTime: record.time) else {
            os_log("Failed to send notification schedule request for booking time.",
                   log: Log.bookNotifError, type: .error)
            return
        }
        let notifTimeToEnter = Notification(
            notifId: notifIdTimeToEnter,
            title: "Time to Enter for Your Booking!",
            description: "\(record.restaurant.name) is waiting for your arrival since \(record.time.toString()).",
            shouldSend: true)
        notifManager.schedule(notif: notifTimeToEnter)
        os_log("Book enter notif sent to schedule.", log: Log.bookNotifScheduled, type: .info)
    }

    /// Sets 4 notifs: 1) admitted 2) 1min mark 3) 2min marl 3) 3min missed queue (pushed back)
    func notifyQueueAdmittance(record: QueueRecord) {
        
    }

    func notifyBookingRejection(record: BookRecord) {
        
    }

    func notifyQueueRejection(record: QueueRecord) {
        
    }

    func retrackNotifications(afterConfirmAdmitFor record: QueueRecord) {
        
    }
}

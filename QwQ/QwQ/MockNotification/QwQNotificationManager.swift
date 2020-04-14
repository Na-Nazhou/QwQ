import Foundation
import os.log

/// Specific to QwQ notifications.
/// Note: private functions are written separately for logging purposes also.
class QwQNotificationManager: QwQNotificationHandler {
    static let shared = QwQNotificationManager()

    let notifManager = LocalNotificationManager()

    /// Sets 2 notifs: 1) accepted 2) schedule for booking time.
    func notifyBookingAcceptance(record: BookRecord) {
        let bookNotifs = [
            accepOrRejectBookingNotification(record, isAccept: true),
            bookTimeNotification(record)
        ]
        bookNotifs.compactMap { $0 }
            .forEach { notifManager.schedule(notif: $0) }
    }

    private func accepOrRejectBookingNotification(_ record: BookRecord, isAccept: Bool) -> QwQNotification? {
        guard let notifId = QwQNotificationId(record: record, timeInMinutesFromAdmittedTime: 0) else {
            os_log("Failed to create id for notification about booking acceptance/rejection.",
                   log: Log.bookNotifError, type: .error)
            return nil
        }

        let keyword = isAccept ? "Accepted" : "Rejected";
        let description = isAccept
            ? "You can now view your accepted booking in the Activities page!"
            : "You may consider booking at other restaurants.";
        let notif = QwQNotification(
            notifId: notifId,
            title: "Booking \(keyword) by \(record.restaurant.name)",
            description: description, shouldSend: true)
        os_log("Book accept/reject notif prepared to be sent to schedule.",
               log: Log.bookNotifScheduled, type: .info)
        return notif
    }

    private func bookTimeNotification(_ record: BookRecord) -> QwQNotification? {
        guard let notifIdTimeToEnter = QwQNotificationId(record: record, targetTime: record.time) else {
            os_log("Failed to create id for notification schedule request for booking time.",
                   log: Log.bookNotifError, type: .error)
            return nil
        }
        let notifTimeToEnter = QwQNotification(
            notifId: notifIdTimeToEnter,
            title: "Time to Enter for Your Booking!",
            description: "\(record.restaurant.name) is waiting for your arrival since \(record.time.toString()).",
            shouldSend: true)
        os_log("Book enter notif prepared to be sent to schedule.",
               log: Log.bookNotifScheduled, type: .info)
        return notifTimeToEnter
    }

    /// Sets 4 notifs: 1) admitted 2) 1min mark 3) 2min marl 3) 3min missed queue (pushed back)
    func notifyQueueAdmittance(record: QueueRecord) {
        let queueNotifs = [
            admitQueueNotification(record),
            admitOneMinNotification(record),
            admitTwoMinsNotification(record),
            missedQueueNotification(record)
        ]
        queueNotifs.compactMap { $0 }
            .forEach { notifManager.schedule(notif: $0) }
    }

    private func admitQueueNotification(_ record: QueueRecord) -> QwQNotification? {
        guard let notifAdmitId = QwQNotificationId(record: record, timeInMinutesFromAdmittedTime: 0) else {
            os_log("Failed to create id for notification about queue admittance.",
                   log: Log.queueNotifError, type: .error)
            return nil
        }
        let notifAdmit = QwQNotification(
            notifId: notifAdmitId,
            title: "Please respond -- \(record.restaurant.name) has admitted you!",
            description: "Accept or reject the admission on the Activities page! \nRespond within: 3 min",
            shouldSend: true)
        os_log("Queue admittance notif prepared to be sent to schedule.",
               log: Log.queueNotifScheduled, type: .info)
        return notifAdmit
    }

    private func admitOneMinNotification(_ record: QueueRecord) -> QwQNotification? {
        guard let notifAdmitId = QwQNotificationId(record: record, timeInMinutesFromAdmittedTime: 1) else {
            os_log("Failed to create id for 1min mark reminder notification.",
                   log: Log.queueNotifError, type: .error)
            return nil
        }
        let notifAdmit = QwQNotification(
            notifId: notifAdmitId,
            title: "2 minutes left to respond -- \(record.restaurant.name) has admitted you!",
            description: "Accept or reject the admission on the Activities page! \nRespond within: 2 min",
            shouldSend: true)
        os_log("Queue admit response (1 min mark) notif prepared to be sent to schedule.",
               log: Log.queueNotifScheduled, type: .info)
        return notifAdmit
    }

    private func admitTwoMinsNotification(_ record: QueueRecord) -> QwQNotification? {
        guard let notifAdmitId = QwQNotificationId(record: record, timeInMinutesFromAdmittedTime: 2) else {
            os_log("Failed to create id for 2min mark reminder notification.",
                   log: Log.queueNotifError, type: .error)
            return nil
        }
        let notifAdmit = QwQNotification(
            notifId: notifAdmitId,
            title: "1 min left to respond -- \(record.restaurant.name) has admitted you!",
            description: "Accept or reject the admission on the Activities page! \nRespond within: 1 min",
            shouldSend: true)
        os_log("Queue admit response (2 min mark) notif prepared to be sent to schedule.",
               log: Log.queueNotifScheduled, type: .info)
        return notifAdmit
    }

    private func missedQueueNotification(_ record: QueueRecord) -> QwQNotification? {
        guard let notifAdmitId = QwQNotificationId(record: record, timeInMinutesFromAdmittedTime: 3) else {
            os_log("Failed to create id for 3min mark missed queue notification.",
                   log: Log.queueNotifError, type: .error)
            return nil
        }
        let notifAdmit = QwQNotification(
            notifId: notifAdmitId,
            title: "Missed queue for: \(record.restaurant.name).",
            description: "You have been pushed back in the queue. Please wait.",
            shouldSend: true)
        os_log("Queue admit missed (3 min mark) notif prepared to be sent to schedule.",
               log: Log.queueNotifScheduled, type: .info)
        return notifAdmit
    }

    func notifyBookingRejection(record: BookRecord) {
        if let rejectNotif = accepOrRejectBookingNotification(record, isAccept: false) {
            notifManager.schedule(notif: rejectNotif)
        }
    }

    func notifyQueueRejection(record: QueueRecord) {
        
    }

    func retrackQueueNotifications(afterConfirmAdmitFor record: QueueRecord) {
        
    }

    // MARK: Helper methods
    private func removeNotifications(notifIds: [QwQNotificationId]) {
        notifManager.removeNotifications(ids: notifIds.map { $0.string })
    }
}

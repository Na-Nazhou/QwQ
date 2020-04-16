import Foundation
import os.log

/// Specific to QwQ notifications.
/// Note: private functions are written separately for logging purposes also.
class QwQNotificationManager: QwQNotificationHandler {
    static let shared = QwQNotificationManager()

    let notifManager = LocalNotificationManager.singleton

    /// Sets 2 notifs: 1) accepted 2) schedule for booking time.
    func notifyBookingAccepted(record: BookRecord) {
        let bookNotifs = [
            accepOrRejectBookingNotification(record, isAccept: true),
            bookTimeNotification(record)
        ]
        bookNotifs.forEach { notifManager.schedule(notif: $0) }
    }

    private func accepOrRejectBookingNotification(_ record: BookRecord, isAccept: Bool) -> QwQNotification {
        var keyword: String
        var description: String
        if isAccept {
            assert(record.admitTime != nil)
            keyword = "Accepted"
            description = "You can now view your accepted booking in the Activities page! Please arrive on time."
        } else {
            assert(record.rejectTime != nil)
            keyword = "Rejected"
            description = "You may consider booking at other restaurants."
        }

        let notifId = QwQNotificationId(record: record, timeDelayInMinutes: 0)

        let notif = QwQNotification(
            notifId: notifId,
            title: "Booking \(keyword) by \(record.restaurant.name)",
            description: description, shouldSend: true)
        os_log("Book accept/reject notif prepared.",
               log: Log.bookNotifScheduled, type: .info)
        return notif
    }

    private func bookTimeNotification(_ record: BookRecord) -> QwQNotification {
        let notifIdTimeToEnter = QwQNotificationId(record: record, targetTime: record.time)
        let notifTimeToEnter = QwQNotification(
            notifId: notifIdTimeToEnter,
            title: "Time to Enter for Your Booking!",
            description: "\(record.restaurant.name) is waiting for your arrival since \(record.time.toString()).",
            shouldSend: true)
        os_log("Book enter notif prepared.",
               log: Log.bookNotifScheduled, type: .info)
        return notifTimeToEnter
    }

    /// Sets 4 notifs: 1) admitted 2) 1min mark 3) 2min marl 3) 3min missed queue (pushed back)
    func notifyQueueAdmittedAwaitingConfirmation(record: QueueRecord) {
        let queueNotifs = [
            admitQueueNotification(record),
            admitOneMinNotification(record),
            admitTwoMinsNotification(record),
            missedQueueNotification(record, hasConfirmedPreviously: false)
        ]
        queueNotifs.forEach { notifManager.schedule(notif: $0) }
    }

    private func admitQueueNotification(_ record: QueueRecord) -> QwQNotification {
        assert(record.admitTime != nil)

        let notifAdmitId = QwQNotificationId(record: record, timeDelayInMinutes: 0)
        let notifAdmit = QwQNotification(
            notifId: notifAdmitId,
            title: "Please respond -- \(record.restaurant.name) has admitted you!",
            description: "Accept or reject the admission on the Activities page! \nRespond within: 3 min",
            shouldSend: true)
        os_log("Queue admittance notif prepared.",
               log: Log.queueNotifScheduled, type: .info)
        return notifAdmit
    }

    private func admitOneMinNotification(_ record: QueueRecord) -> QwQNotification {
        assert(record.admitTime != nil)
        return withdrawableAdmitOneMinNotification(record)
    }

    private func withdrawableAdmitOneMinNotification(_ record: QueueRecord) -> QwQNotification {
        let notifAdmitId = QwQNotificationId(record: record, timeDelayInMinutes: 1)
        let notifAdmit = QwQNotification(
            notifId: notifAdmitId,
            title: "2 minutes left to respond -- \(record.restaurant.name) has admitted you!",
            description: "Accept or reject the admission on the Activities page! \nRespond within: 2 min",
            shouldSend: true)
        os_log("Queue admit response (1 min mark) notif prepared.",
               log: Log.queueNotifScheduled, type: .info)
        return notifAdmit
    }

    private func admitTwoMinsNotification(_ record: QueueRecord) -> QwQNotification {
        assert(record.admitTime != nil)
        return withdrawableAdmitTwoMinsNotification(record)
    }

    private func withdrawableAdmitTwoMinsNotification(_ record: QueueRecord) -> QwQNotification {
        let notifAdmitId = QwQNotificationId(record: record, timeDelayInMinutes: 2)
        let notifAdmit = QwQNotification(
            notifId: notifAdmitId,
            title: "1 min left to respond -- \(record.restaurant.name) has admitted you!",
            description: "Accept or reject the admission on the Activities page! \nRespond within: 1 min",
            shouldSend: true)
        os_log("Queue admit response (2 min mark) notif prepared.",
               log: Log.queueNotifScheduled, type: .info)
        return notifAdmit
    }

    private func missedQueueNotification(_ record: QueueRecord, hasConfirmedPreviously: Bool) -> QwQNotification {
        assert(record.admitTime != nil)
        return withdrawableMissedQueueNotification(record, hasConfirmedPreviously: hasConfirmedPreviously)
    }

    private func withdrawableMissedQueueNotification(
        _ record: QueueRecord, hasConfirmedPreviously: Bool) -> QwQNotification {
        let timeInterval = hasConfirmedPreviously ? 15 : 3

        let notifAdmitId = QwQNotificationId(record: record, timeDelayInMinutes: timeInterval)
        let notifAdmit = QwQNotification(
            notifId: notifAdmitId,
            title: "Missed queue for: \(record.restaurant.name).",
            description: "You have been pushed back in the queue. Please wait in the vicinity.",
            shouldSend: true)
        os_log("Queue admit missed notif prepared.",
               log: Log.queueNotifScheduled, type: .info)
        return notifAdmit
    }

    func notifyBookingRejected(record: BookRecord) {
        let rejectNotif = accepOrRejectBookingNotification(record, isAccept: false)
        notifManager.schedule(notif: rejectNotif)
    }

    func notifyQueueConfirmed(record: QueueRecord) {
        let notifs = [
            confirmedAdmissionNotification(record),
            missedQueueNotification(record, hasConfirmedPreviously: true)
        ]
        notifs.forEach { notifManager.schedule(notif: $0) }
    }

    private func confirmedAdmissionNotification(_ record: QueueRecord) -> QwQNotification {
        assert(record.confirmAdmissionTime != nil)
        let refTime = record.confirmAdmissionTime!

        let notifId = QwQNotificationId(record: record, timeDelayInMinutes: 0, afterReference: refTime)
        let notif = QwQNotification(
            notifId: notifId,
            title: "Seats confirmed for \(record.restaurant.name)!",
            description: "Please arrive within 15min from the admitted time.",
            shouldSend: true)
        os_log("Queue confirm admit notif prepared.",
               log: Log.queueNotifScheduled, type: .info)
        return notif
    }

    func notifyQueueRejected(record: QueueRecord) {
        //TODO? - yes. do for end of restaurant.
    }

    func retractBookNotifications(for record: BookRecord) {
        let possiblyPendingBookNotif = bookTimeNotification(record)
        os_log("Book notifs prepared to be withdrawn.", log: Log.withdrawNotif)
        removeNotifications(notifIds: [possiblyPendingBookNotif.notifId])
    }

    func retractQueueNotifications(for record: QueueRecord) {
        let possiblyPendingQueueNotifs = [
            withdrawableAdmitOneMinNotification(record),
            withdrawableAdmitTwoMinsNotification(record),
            withdrawableMissedQueueNotification(record, hasConfirmedPreviously: false),
            withdrawableMissedQueueNotification(record, hasConfirmedPreviously: true)
        ]
        os_log("Queue notifs prepared to be withdrawn.", log: Log.withdrawNotif)
        removeNotifications(notifIds: possiblyPendingQueueNotifs.map { $0.notifId })
    }

    // MARK: Helper methods
    private func removeNotifications(notifIds: [QwQNotificationId]) {
        notifManager.removeNotifications(ids: notifIds.map { $0.toString })
    }
}

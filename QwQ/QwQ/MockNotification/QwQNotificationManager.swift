import Foundation
import os.log

/// A QwQ notification handler that creates and schedules QwQ notifications.
/// Note: private functions are written separately for logging purposes also.
class QwQNotificationManager: QwQNotificationHandler {
    static let shared = QwQNotificationManager()

    let notifManager = LocalNotificationManager.singleton

    /// Schedules notifications related to booking acceptance.
    func notifyBookingAccepted(record: BookRecord) {
        // 2 notifications are scheduled when a customer's booking is accepted:
        // 1) notify that customer is accepted for a booking
        // 2) notify customer that it is time to attend the booking
        let bookNotifs = [
            accepOrRejectBookingNotification(record, isAccept: true),
            bookTimeNotification(record)
        ]
        bookNotifs.forEach { notifManager.schedule(notif: $0) }
    }

    /// Creates a notification to notify customer's booking is accepted/rejected.
    /// - Parameters:
    ///     - record: The record that is accepted/rejected.
    ///     - isAccept: `false` if `record` is rejected, `true` otherwise.
    /// - Requires: `record` must either have a non-nil `admitTime` or `rejectTime`.
    /// - Returns:A notification with messages set and time scheduled to trigger immediately.
    private func accepOrRejectBookingNotification(_ record: BookRecord, isAccept: Bool) -> QwQNotification {
        var keyword: String
        var description: String
        if isAccept {
            assert(record.admitTime != nil)
            keyword = Constants.acceptKeyword
            description = Constants.bookingAcceptedMessage
        } else {
            assert(record.rejectTime != nil)
            keyword = Constants.rejectKeyword
            description = Constants.bookingRejectedMessage
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

    /// Creates a notification to notify customer to attend his booking.
    /// - Parameters:
    ///     - record: The record that is accepted.
    /// - Returns:A notification with messages set and time scheduled to trigger at the booked time.
    private func bookTimeNotification(_ record: BookRecord) -> QwQNotification {
        let notifIdTimeToEnter = QwQNotificationId(record: record, targetTime: record.time)
        let notifTimeToEnter = QwQNotification(
            notifId: notifIdTimeToEnter,
            title: Constants.bookingAdmittedTitle,
            description: "\(record.restaurant.name) is waiting for your arrival since \(record.time.toString()).",
            shouldSend: true)
        os_log("Book enter notif prepared.",
               log: Log.bookNotifScheduled, type: .info)
        return notifTimeToEnter
    }

    /// Schedules notifications related to the admission of a record.
    func notifyQueueAdmittedAwaitingConfirmation(record: QueueRecord) {
        // 3 notifications are scheduled when a customer is admitted in a queue:
        // 1) notify the customer is admitted and needs to confirm
        // 2) notify the customer has 2 min left to confirm
        // 3) notify the customer has 1 min left to confirm
        let queueNotifs = [
            admitQueueNotification(record),
            admitOneMinNotification(record),
            admitTwoMinsNotification(record)
        ]
        queueNotifs.forEach { notifManager.schedule(notif: $0) }
    }

    /// Creates a notification to notify the customer is admitted and needs to confirm his attendance.
    /// - Parameters:
    ///     - record: The record that is admitted.
    /// - Requires: `record` must have a non-nil `admitTime`.
    /// - Returns:A notification with messages set and time scheduled to trigger immediately at admission time.
    private func admitQueueNotification(_ record: QueueRecord) -> QwQNotification {
        assert(record.admitTime != nil)

        // the time to be taken is the latest admission time
        var refTime = record.admitTime!
        if record.readmitTime != nil {
            refTime = record.readmitTime!
        }

        let notifAdmitId = QwQNotificationId(record: record, timeDelayInMinutes: 0, afterReference: refTime)
        let notifAdmit = QwQNotification(
            notifId: notifAdmitId,
            title: "Please respond -- \(record.restaurant.name) has admitted you!",
            description: Constants.queueAdmittedMessage,
            shouldSend: true)
        os_log("Queue admittance notif prepared.",
               log: Log.queueNotifScheduled, type: .info)
        return notifAdmit
    }

    /// Creates a notification to be triggered 1 min after customer's queue is admitted.
    /// - Parameters:
    ///     - record: The record that is admitted.
    /// - Requires: `record` must have a non-nil `admitTime`.
    /// - Returns:A notification with messages set and time scheduled to trigger 1 min after the time of admission.
    private func admitOneMinNotification(_ record: QueueRecord) -> QwQNotification {
        assert(record.admitTime != nil)
        return withdrawableAdmitOneMinNotification(record)
    }

    /// Creates a wtihdrawable notification that can trigger at 1 min after queue admission.
    /// The latest admission time is chosen as reference. If record was never admitted, the hypothetical
    /// notification can still be created, but the reference time is taken to be the current time.
    /// - Parameters:
    ///     - record: The record that is admitted.
    /// - Returns:A notification with messages set and time scheduled to trigger 1 min after the time of admission.
    private func withdrawableAdmitOneMinNotification(_ record: QueueRecord) -> QwQNotification {
        var refTime = Date()
        if record.readmitTime != nil {
            refTime = record.readmitTime!
        } else if record.admitTime != nil {
            refTime = record.admitTime!
        }

        let notifAdmitId = QwQNotificationId(record: record, timeDelayInMinutes: 1, afterReference: refTime)
        let notifAdmit = QwQNotification(
            notifId: notifAdmitId,
            title: "2 minutes left to respond -- \(record.restaurant.name) has admitted you!",
            description: Constants.queueAdmit1minMessage,
            shouldSend: true)
        os_log("Queue admit response (1 min mark) notif prepared.",
               log: Log.queueNotifScheduled, type: .info)
        return notifAdmit
    }

    /// Creates a notification to be triggered 2 min after customer's queue is admitted.
    /// - Parameters:
    ///     - record: The record that is admitted.
    /// - Requires: `record` must have a non-nil `admitTime`.
    /// - Returns:A notification with messages set and time scheduled to trigger 2 min after the time of admission.
    private func admitTwoMinsNotification(_ record: QueueRecord) -> QwQNotification {
        assert(record.admitTime != nil)
        return withdrawableAdmitTwoMinsNotification(record)
    }

    /// Creates a wtihdrawable notification that can trigger at 2 min after queue admission.
    /// The latest admission time is chosen as reference. If record was never admitted, the hypothetical
    /// notification can still be created, but the reference time is taken to be the current time.
    /// - Parameters:
    ///     - record: The record that is admitted.
    /// - Returns:A notification with messages set and time scheduled to trigger 2 min after the time of admission.
    private func withdrawableAdmitTwoMinsNotification(_ record: QueueRecord) -> QwQNotification {
        var refTime = Date()
        if record.readmitTime != nil {
            refTime = record.readmitTime!
        } else if record.admitTime != nil {
            refTime = record.admitTime!
        }

        let notifAdmitId = QwQNotificationId(record: record, timeDelayInMinutes: 2, afterReference: refTime)
        let notifAdmit = QwQNotification(
            notifId: notifAdmitId,
            title: "1 min left to respond -- \(record.restaurant.name) has admitted you!",
            description: Constants.queueAdmit2minMessage,
            shouldSend: true)
        os_log("Queue admit response (2 min mark) notif prepared.",
               log: Log.queueNotifScheduled, type: .info)
        return notifAdmit
    }

    /// Schedules notification to notify customer is rejected for his booking.
    func notifyBookingRejected(record: BookRecord) {
        let rejectNotif = accepOrRejectBookingNotification(record, isAccept: false)
        notifManager.schedule(notif: rejectNotif)
    }

    /// Schedules notification to notify customer has confirmed and needs to arrive promptly for his queue.
    func notifyQueueConfirmed(record: QueueRecord) {
        notifManager.schedule(notif: confirmedAdmissionNotification(record))
    }

    /// Creates a notification to be triggered when customer has confirmed admission.
    /// - Parameters:
    ///     - record: The record that is admitted.
    /// - Requires: `record` must have a non-nil `confirmAdmissionTime`.
    /// - Returns:A notification with messages set and time scheduled to immediately after customer confirmed admission.
    private func confirmedAdmissionNotification(_ record: QueueRecord) -> QwQNotification {
        assert(record.confirmAdmissionTime != nil)
        let refTime = record.confirmAdmissionTime!

        let notifId = QwQNotificationId(record: record, timeDelayInMinutes: 0, afterReference: refTime)
        let notif = QwQNotification(
            notifId: notifId,
            title: "Seats confirmed for \(record.restaurant.name)!",
            description: Constants.queueConfirmedAdmissionMessage,
            shouldSend: true)
        os_log("Queue confirm admit notif prepared.",
               log: Log.queueNotifScheduled, type: .info)
        return notif
    }

    /// Schedules a notificatiion to notify the cusomer is rejected for his queue.
    func notifyQueueRejected(record: QueueRecord) {
        assert(record.rejectTime != nil)
        let notifId = QwQNotificationId(record: record, timeDelayInMinutes: 0, afterReference: record.rejectTime!)
        let notif = QwQNotification(
            notifId: notifId,
            title: "You have been rejected by \(record.restaurant.name).",
            description: Constants.queueRejectedMessage,
            shouldSend: true)
        
        os_log("Queue rejection notif scheduled.")
        notifManager.schedule(notif: notif)
    }
    
    /// Schedules a notification to notify the customer has missed his queue admission.
    func notifyQueueMissed(record: QueueRecord) {
        assert(record.missTime != nil)
        let notifMissId = QwQNotificationId(record: record, timeDelayInMinutes: 0, afterReference: record.missTime!)
        let notifMiss = QwQNotification(
            notifId: notifMissId,
            title: "Missed queue for: \(record.restaurant.name).",
            description: Constants.queueMissedMessage,
            shouldSend: true)
        os_log("Queue admit missed notif prepared.",
               log: Log.queueNotifScheduled, type: .info)

        notifManager.schedule(notif: notifMiss)
    }
   
    /// Retracts all pending notifications for `record`.
    ///  - Note: Only existing pending notifications will be removed.
    func retractBookNotifications(for record: BookRecord) {
        // The only possible pending notification is the notification
        // scheduled to trigger at time of booking.
        let possiblyPendingBookNotif = bookTimeNotification(record)
        os_log("Book notifs prepared to be withdrawn.", log: Log.withdrawNotif)
        removeNotifications(notifIds: [possiblyPendingBookNotif.notifId])
    }

    /// Retracts all pending notifications for `record`.
    ///  - Note: Only existing pending notifications will be removed.
    func retractQueueNotifications(for record: QueueRecord) {
        // Possibly pending notifications include the reminders to confirm admission.
        let possiblyPendingQueueNotifs = [
            withdrawableAdmitOneMinNotification(record),
            withdrawableAdmitTwoMinsNotification(record)
        ]
        os_log("Queue notifs prepared to be withdrawn.", log: Log.withdrawNotif)
        removeNotifications(notifIds: possiblyPendingQueueNotifs.map { $0.notifId })
    }

    /// Removes notifications with the ids in `notifIds` from being scheduled.
    private func removeNotifications(notifIds: [QwQNotificationId]) {
        notifManager.removeNotifications(ids: notifIds.map { $0.toString })
    }
}

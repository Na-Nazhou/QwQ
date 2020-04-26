/// Represents a notification handler for QwQ. Sends commands to the UNUserNotifications Framework on behalf of QwQ.
/// Note that retract notification methods retract all related pending notifications.
/// Usually, one should retract notifications before sending desired notifications.
protocol QwQNotificationHandler {
    /// Sends notification(s) to notify customer he is accepted.
    func notifyBookingAccepted(record: BookRecord)
    /// Sends notification(s) to notify customer he is admitted and needs to confirm attendance.
    func notifyQueueAdmittedAwaitingConfirmation(record: QueueRecord)
    
    /// Sends notification(s) to notify customer his admission is confirmed and should reach the restaurant promptly.
    func notifyQueueConfirmed(record: QueueRecord)
    /// Sends notification(s) to notify customer he missed his admission and needs to wait.
    func notifyQueueMissed(record: QueueRecord)

    /// Sends notification(s) to notify customer his booking is rejected by the restaurant.
    func notifyBookingRejected(record: BookRecord)
    /// Sends notification(s) to notify customer hhis queue is rejected by the restaurant.
    func notifyQueueRejected(record: QueueRecord)

    /// Retracts all pending notifications of `record`.
    func retractBookNotifications(for record: BookRecord)
    /// Retracts all pending notifications of `record`.
    func retractQueueNotifications(for record: QueueRecord)
}

/// Notification handler for QwQ. Sends commands to the UNUserNotifications Framework on behalf of QwQ.
/// Note that retract notification methods retract all related notifications. Retract notifications before sending your desired notifications.
protocol QwQNotificationHandler {
    func notifyBookingAccepted(record: BookRecord)
    func notifyQueueAdmittedAwaitingConfirmation(record: QueueRecord)
    
    func notifyQueueConfirmed(record: QueueRecord)

    func notifyBookingRejected(record: BookRecord)
    
    //TODO: do we still allow restaurants to reject
    func notifyQueueRejected(record: QueueRecord)

    func retractBookNotifications(for record: BookRecord)
    func retractQueueNotifications(for record: QueueRecord)
}

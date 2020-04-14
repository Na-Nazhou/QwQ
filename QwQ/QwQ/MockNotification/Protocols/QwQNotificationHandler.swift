protocol QwQNotificationHandler {
    func notifyBookingAccepted(record: BookRecord)
    func notifyQueueAdmittedAwaitingConfirmation(record: QueueRecord)
    
    func notifyQueueConfirmed(record: QueueRecord)

    func notifyBookingRejected(record: BookRecord)
    
    //TODO: do we still allow restaurants to reject
    func notifyQueueRejected(record: QueueRecord)

    func retrackQueueNotifications(for record: QueueRecord)
}

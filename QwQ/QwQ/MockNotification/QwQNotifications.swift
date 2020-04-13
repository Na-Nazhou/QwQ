protocol QwQNotifications {
    func notifyBookingAcceptance(record: BookRecord)
    func notifyQueueAdmittance(record: QueueRecord)

    func notifyBookingRejection(record: BookRecord)
    func notifyQueueRejection(record: QueueRecord) //TODO: do we still allow restaurants to reject

    func retrackNotifications(afterConfirmAdmitFor record: QueueRecord)
}

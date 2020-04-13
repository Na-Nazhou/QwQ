protocol QwQNotifications {
    func notifyBookingAcceptance()
    func notifyQueueAdmittance()

    func notifyBookingRejection()
    func notifyQueueRejection() //TODO: do we still allow restaurants to reject

    func retrackNotifications(afterConfirmAdmitFor record: QueueRecord)
}

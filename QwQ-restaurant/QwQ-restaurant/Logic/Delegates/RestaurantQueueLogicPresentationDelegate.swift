protocol RestaurantQueueLogicPresentationDelegate: AnyObject {
    func restaurantDidChangeQueueStatus(toIsOpen: Bool)

    func didAddRecordToQueue(record: QueueRecord)
    func didRemoveRecordFromQueue(record: QueueRecord)
    func didUpdateRecordInQueue(to new: QueueRecord)

    func didAddRecordToWaiting(toWaiting record: QueueRecord)
    func didRemoveRecordFromWaiting(record: QueueRecord)
}

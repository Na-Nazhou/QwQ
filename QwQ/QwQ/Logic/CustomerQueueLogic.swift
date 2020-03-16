/// Represents the protocol for customer side's queue logic. There can be up to one active queue record at any one time;
/// customers are not allowed to queue for another restaurant while in an active queue.
protocol CustomerQueueLogic: QueueStorageSyncDelegate {
    var queueStorage: CustomerQueueStorage { get set }
    var currentQueueRecord: QueueRecord? { get set }

    func loadCurrentQueueRecord()

    func enqueue(to restaurant: Restaurant,
                 with groupSize: Int,
                 babyChairQuantity: Int,
                 wheelchairFriendly: Bool) -> String?

    func editQueueRecord(with groupSize: Int,
                         babyChairQuantity: Int,
                         wheelchairFriendly: Bool)

    func deleteQueueRecord()
}

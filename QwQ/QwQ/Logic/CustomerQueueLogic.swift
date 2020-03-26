/// Represents the protocol for customer side's queue logic. There can be up to one active queue record at any one time;
/// customers are not allowed to queue for another restaurant while in an active queue.
protocol CustomerQueueLogic: QueueStorageSyncDelegate {
    // Storage
    var queueStorage: CustomerQueueStorage { get set }

    // View Controllers
    var queueDelegate: RecordDelegate? { get set }
    var activitiesDelegate: ActivitiesDelegate? { get set }

    var currentQueueRecord: QueueRecord? { get set }

    func enqueue(to restaurant: Restaurant,
                 with groupSize: Int,
                 babyChairQuantity: Int,
                 wheelchairFriendly: Bool)

    func editQueueRecord(oldRecord: QueueRecord,
                         with groupSize: Int,
                         babyChairQuantity: Int,
                         wheelchairFriendly: Bool)

    func deleteQueueRecord(_ queueRecord: QueueRecord)
}

/// Represents the protocol for customer side's queue logic. There can be up to one active queue record at any one time;
/// customers are not allowed to queue for another restaurant while in an active queue.
protocol CustomerQueueLogic: QueueStorageSyncDelegate {

    // View Controllers
    var queueDelegate: QueueDelegate? { get set }
    var searchDelegate: SearchDelegate? { get set }
    var activitiesDelegate: ActivitiesDelegate? { get set }

    func enqueue(to restaurant: Restaurant,
                 with groupSize: Int,
                 babyChairQuantity: Int,
                 wheelchairFriendly: Bool) -> Bool

    func enqueue(to restaurants: [Restaurant],
                 with groupSize: Int,
                 babyChairQuantity: Int,
                 wheelchairFriendly: Bool) -> Bool

    func editQueueRecord(oldRecord: QueueRecord,
                         with groupSize: Int,
                         babyChairQuantity: Int,
                         wheelchairFriendly: Bool)

    func withdrawQueueRecord(_ queueRecord: QueueRecord)
}

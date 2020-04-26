/// Represents the protocol a customer queue logic handler should conform to.
protocol CustomerQueueLogic: QueueStorageSyncDelegate {

    // View Controllers
    /// Presentation delegate of queue record.
    var queueDelegate: QueueDelegate? { get set }
    /// Presentation delegate of search results.
    var searchDelegate: SearchDelegate? { get set }
    /// Presentation delegate of queue activities.
    var activitiesDelegate: ActivitiesDelegate? { get set }

    /// Returns true iff customer is allowed to queue at `restaurant`.
    func canQueue(for restaurant: Restaurant) -> Bool
    /// Enqueues the customer at `restaurants` with the specified attendee details.
    func enqueue(to restaurants: [Restaurant],
                 with groupSize: Int,
                 babyChairQuantity: Int,
                 wheelchairFriendly: Bool) -> Bool

    /// Edits `oldRecord` with the specified attendee details.
    func editQueueRecord(oldRecord: QueueRecord,
                         with groupSize: Int,
                         babyChairQuantity: Int,
                         wheelchairFriendly: Bool)

    /// Withdraws `queueRecord`.
    func withdrawQueueRecord(_ queueRecord: QueueRecord)

    /// Confirms admission of `record`.
    func confirmAdmissionOfQueueRecord(_ record: QueueRecord)
}

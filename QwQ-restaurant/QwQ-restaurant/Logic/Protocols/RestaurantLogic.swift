/// Represents the protocol a logic handler of restaurants should conform to.
protocol RestaurantLogic: RestaurantStorageSyncDelegate {

    // MARK: View Controllers
    /// Presentation delegate of restaurant activities.
    var activitiesDelegate: ActivitiesDelegate? { get set }

    // MARK: Models
    var isQueueOpen: Bool { get }

    /// Opens queue.
    func openQueue()
    /// Closes queue.
    func closeQueue()
}

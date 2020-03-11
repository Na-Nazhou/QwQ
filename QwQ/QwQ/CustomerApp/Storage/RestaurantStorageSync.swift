protocol RestaurantStorageSync {
    var logicDelegate: RestaurantStorageSyncDelegate? { get set }

    /// Notify when a restaurant is opened
    func didOpenQueue(restaurant: Restaurant)
    /// Notify when a restaurant is closed
    func didCloseQueue(restaurant: Restaurant)
}

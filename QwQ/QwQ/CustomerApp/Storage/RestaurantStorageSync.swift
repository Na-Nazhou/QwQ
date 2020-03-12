/// Represents the protocol needed to sync restaurant pages on customer's end.
protocol RestaurantStorageSyncDelegate: AnyObject {
    func restaurantDidOpenQueue(restaurant: Restaurant)
    func restaurantDidCloseQueue(restaurant: Restaurant)
}

protocol RestaurantStorageSync {
    var logicDelegate: RestaurantStorageSyncDelegate? { get set }

    /// Notify when a restaurant is opened
    func didOpenQueue(restaurant: Restaurant)
    /// Notify when a restaurant is closed
    func didCloseQueue(restaurant: Restaurant)
}

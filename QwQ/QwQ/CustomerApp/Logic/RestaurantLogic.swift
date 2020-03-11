/// Represents the queue protocol needed to sync when storage notifies of any changes.
protocol RestaurantStorageSyncDelegate {
    func didOpenQueue(restaurant: Restaurant)
    func didCloseQueue(restaurant: Restaurant)
}

/// Represents the entire queue logic protocol needed for the application.
protocol RestaurantLogic: RestaurantStorageSyncDelegate {
    var restaurantStorage: RestaurantStorage { get set }
    var openRestaurants: [Restaurant] { get set }

    func loadOpenRestaurants()
}

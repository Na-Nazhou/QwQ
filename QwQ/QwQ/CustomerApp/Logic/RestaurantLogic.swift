/// Protocol for delegate of restaurant loggic presentation to follow.
protocol RestaurantLogicDelegate {
    func restaurantDidSetQueueStatus(of restaurant: Restaurant, toIsOpen isOpen: Bool)
}

/// Represents the protocol for a restaurant page that customers view.
protocol RestaurantLogic: RestaurantStorageSyncDelegate {
    var currentlyOpenRestaurantPage: RestaurantLogicDelegate?

    var restaurantStorage: RestaurantStorage { get set }
    var openRestaurants: [Restaurant] { get set }

    func loadOpenRestaurants()
}

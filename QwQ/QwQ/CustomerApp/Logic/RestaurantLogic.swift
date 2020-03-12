/// Protocol for delegate of restaurant loggic presentation to follow.
protocol RestaurantLogicDelegate: AnyObject {
    func restaurantDidSetQueueStatus(of restaurant: Restaurant, toIsOpen isOpen: Bool)
}

/// Represents the protocol for a restaurant page that customers view.
protocol RestaurantLogic: RestaurantStorageSyncDelegate {
    var currentlyOpenRestaurantPage: RestaurantLogicDelegate? { get set }

    var restaurantStorage: RestaurantStorage { get }
    var openRestaurants: [Restaurant] { get set }

    func loadOpenRestaurants()
}

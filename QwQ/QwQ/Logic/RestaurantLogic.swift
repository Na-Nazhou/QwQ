/// Represents the protocol for a restaurant page that customers view.
protocol RestaurantLogic: RestaurantStorageSyncDelegate {
    var currentlyOpenRestaurantPage: RestaurantDelegate? { get set }

    var restaurantStorage: RestaurantStorage { get }
    var openRestaurants: [Restaurant] { get set }

    func loadOpenRestaurants()
}

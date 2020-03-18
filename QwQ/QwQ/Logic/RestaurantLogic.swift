/// Represents the protocol for a restaurant page that customers view.
protocol RestaurantLogic: RestaurantStorageSyncDelegate {
    // Storage
    var restaurantStorage: RestaurantStorage { get }

    // View Controllers
    var restaurantDelegate: RestaurantDelegate? { get set }
    var searchDelegate: SearchDelegate? { get set }

    var restaurants: [Restaurant] { get set }

    func fetchRestaurants()
}

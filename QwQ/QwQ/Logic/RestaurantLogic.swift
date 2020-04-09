/// Represents the protocol for a restaurant page that customers view.
protocol RestaurantLogic: RestaurantStorageSyncDelegate {

    // View Controllers
    var restaurantDelegate: RestaurantDelegate? { get set }
    var searchDelegate: SearchDelegate? { get set }

    var restaurants: [Restaurant] { get }
    var currentRestaurant: Restaurant? { get set }
    var currentRestaurants: [Restaurant] { get set }
}

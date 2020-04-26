/// Represents the protocol a restaurant page that customers view should conform to.
protocol RestaurantLogic: RestaurantStorageSyncDelegate {

    // MARK: View Controllers
    /// Presentation delegate of restaurant,
    var restaurantDelegate: RestaurantDelegate? { get set }
    /// Presentation delegate of search results.
    var searchDelegate: SearchDelegate? { get set }

    // MARK: Models
    var restaurants: [Restaurant] { get }
    var currentRestaurant: Restaurant? { get set }
    var currentRestaurants: [Restaurant] { get set }
}

/// Represents the protocol needed to sync restaurant pages on customer's end.
protocol RestaurantStorageSyncDelegate: AnyObject {

    /// Adds restaurant to collection of restaurants.
    func didAddRestaurant(restaurant: Restaurant)

    /// Updates collection of restaurants when updated. 
    func didUpdateRestaurant(restaurant: Restaurant)

    /// Removes restaurant from collection of restaurants.
    func didRemoveRestaurant(restaurant: Restaurant)

}

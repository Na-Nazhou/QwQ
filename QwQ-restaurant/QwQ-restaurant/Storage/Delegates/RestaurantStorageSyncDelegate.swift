/// Represents the protocol any restaurant storage syncing delegates need to conform to.
protocol RestaurantStorageSyncDelegate: AnyObject {
    
    /// Updates the restaurant in the collection of restaurants.
    func didUpdateRestaurant(restaurant: Restaurant)

}

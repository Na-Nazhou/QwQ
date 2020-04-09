/// Represents the protocol needed to sync restaurant pages on customer's end.
protocol RestaurantStorageSyncDelegate: AnyObject {

    func didAddRestaurant(restaurant: Restaurant)

    /// Updates collection of restaurants when updated. 
    func didUpdateRestaurant(restaurant: Restaurant)

    func didRemoveRestaurant(restaurant: Restaurant)

}

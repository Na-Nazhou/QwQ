/// Represents the protocol needed to sync restaurant pages on customer's end.
protocol RestaurantStorageSyncDelegate: AnyObject {

    func didUpdateRestaurant(restaurant: Restaurant)
}

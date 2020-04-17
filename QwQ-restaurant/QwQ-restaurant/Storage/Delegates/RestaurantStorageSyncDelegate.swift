/// Represents the protocol any restaurant storage syncing delegates need to conform to.
protocol RestaurantStorageSyncDelegate: AnyObject {

    func didUpdateRestaurant(restaurant: Restaurant)

}

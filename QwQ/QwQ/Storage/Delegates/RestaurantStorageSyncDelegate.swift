/// Represents the protocol needed to sync restaurant pages on customer's end.
protocol RestaurantStorageSyncDelegate: AnyObject {
    func restaurantDidModifyProfile(restaurant: Restaurant)

    func didAddNewRestaurant(restaurant: Restaurant)
    func didRemoveRestaurant(restaurant: Restaurant)
}

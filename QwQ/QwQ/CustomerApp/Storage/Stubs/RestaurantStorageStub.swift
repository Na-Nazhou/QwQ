class RestaurantStorageStub: RestaurantStorage {
    weak var logicDelegate: RestaurantStorageSyncDelegate?

    func restaurantDidOpenQueue(restaurant: Restaurant) {
        logicDelegate?.restaurantDidOpenQueue(restaurant: restaurant)
    }

    func restaurantDidCloseQueue(restaurant: Restaurant) {
        logicDelegate?.restaurantDidOpenQueue(restaurant: restaurant)
    }

    func loadAllRestaurants() -> [Restaurant] {
        //firebase load all restaurants
        return []
    }
}

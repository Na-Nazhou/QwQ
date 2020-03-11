class RestaurantLogicManager: RestaurantLogic {
    var restaurantStorage: RestaurantStorage = RestaurantStorageStub()

    var openRestaurants = [Restaurant]()

    func loadOpenRestaurants() {
    }

    func didOpenQueue(restaurant: Restaurant) {
    }

    func didCloseQueue(restaurant: Restaurant) {
    }
}

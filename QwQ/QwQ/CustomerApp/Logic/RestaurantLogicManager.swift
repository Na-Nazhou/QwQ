class RestaurantLogicManager: RestaurantLogic {
    var currentlyOpenRestaurantPage: RestaurantLogicDelegate?

    var restaurantStorage: RestaurantStorage = RestaurantStorageStub()

    var openRestaurants = [Restaurant]()

    func loadOpenRestaurants() {
    }

    func restaurantDidOpenQueue(restaurant: Restaurant) {
    }

    func restaurantDidCloseQueue(restaurant: Restaurant) {
    }
}

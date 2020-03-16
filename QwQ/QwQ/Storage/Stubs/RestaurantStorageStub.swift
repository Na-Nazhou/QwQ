class RestaurantStorageStub: RestaurantStorage {
    weak var logicDelegate: RestaurantStorageSyncDelegate?

    func restaurantDidOpenQueue(restaurant: Restaurant) {
        logicDelegate?.restaurantDidOpenQueue(restaurant: restaurant)
    }

    func restaurantDidCloseQueue(restaurant: Restaurant) {
        logicDelegate?.restaurantDidOpenQueue(restaurant: restaurant)
    }

    func loadAllRestaurants() -> [Restaurant] {
        return [
        Restaurant(uid: "1", name: "restaurant1", email: "j@mail.com", contact: "12345678",
                   address: "location", menu: "menu", isOpen: true),
        Restaurant(uid: "2", name: "restaurant2", email: "k@mail.com", contact: "12345678",
                   address: "location", menu: "menu", isOpen: false),
        Restaurant(uid: "3", name: "restaurant3", email: "l@mail.com", contact: "12345678",
                   address: "location", menu: "menu", isOpen: true)
        ]
    }
}

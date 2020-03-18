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
                       address: "location1", menu: "menu1", isOpen: true),
            Restaurant(uid: "2", name: "restaurant2", email: "k@mail.com", contact: "12345678",
                       address: "location2", menu: "menu2", isOpen: true),
            Restaurant(uid: "3", name: "restaurant3", email: "l@mail.com", contact: "12345678",
                       address: "location3", menu: "menu3", isOpen: false)
        ]
    }
}

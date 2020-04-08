class RestaurantLogicManager: RestaurantLogic {

    // Storage
    private(set) var restaurantStorage: RestaurantStorage
    
    // View Controllers
    weak var restaurantDelegate: RestaurantDelegate?
    weak var searchDelegate: SearchDelegate?

    var currentRestaurant: Restaurant?

    private var restaurantCollection = Collection<Restaurant>()
    var restaurants: [Restaurant] {
        Array(restaurantCollection.restaurants)
    }

    convenience init() {
        self.init(storage: FIRRestaurantStorage.shared)
    }

    init(storage: FIRRestaurantStorage) {
        self.restaurantStorage = storage

        self.restaurantStorage.registerDelegate(self)
    }

    deinit {
        restaurantStorage.unregisterDelegate(self)
    }
    
    func didUpdateRestaurant(restaurant: Restaurant) {
        if restaurantCollection.update(restaurant) {
            if restaurant == currentRestaurant {
                currentRestaurant = restaurant
                restaurantDelegate?.didUpdateRestaurant()
            }

            searchDelegate?.didUpdateRestaurantCollection()
        }
    }

    func didAddRestaurant(restaurant: Restaurant) {
        if restaurantCollection.add(restaurant) {
            searchDelegate?.didUpdateRestaurantCollection()
        }
    }

    func didRemoveRestaurant(restaurant: Restaurant) {
        if restaurantCollection.remove(restaurant) {
            searchDelegate?.didUpdateRestaurantCollection()
        }
    }
}

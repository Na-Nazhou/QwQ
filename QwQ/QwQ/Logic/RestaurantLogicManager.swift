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
    
    func restaurantDidModifyProfile(restaurant: Restaurant) {
        switch restaurantCollection.update(into: restaurant) {
        case .changedProfileDetails:
            break
        case .changedQueueStatus:
            didChangeQueueStatus(restaurant: restaurant)
        }
    }
    
    func didChangeQueueStatus(restaurant: Restaurant) {
        if restaurant == currentRestaurant {
            currentRestaurant = restaurant
            restaurantDelegate?.restaurantDidUpdate()
        }
        
        searchDelegate?.restaurantDidSetQueueStatus(restaurant: restaurant, toIsOpen: restaurant.isQueueOpen)
        
    }

    func didAddRestaurant(restaurant: Restaurant) {
        if restaurantCollection.add(restaurant) {
            searchDelegate?.restaurantCollectionDidLoadNewRestaurant()
        }
    }

    func didRemoveRestaurant(restaurant: Restaurant) {
        if restaurantCollection.remove(restaurant) {
            searchDelegate?.restaurantCollectionDidRemoveRestaurant()
        }
    }
}

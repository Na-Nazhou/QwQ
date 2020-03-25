class RestaurantLogicManager: RestaurantLogic {
    // Storage
    private(set) var restaurantStorage: RestaurantStorage
    
    // View Controllers
    weak var restaurantDelegate: RestaurantDelegate?
    weak var searchDelegate: SearchDelegate?
    
    var customer: Customer
    var currentRestaurant: Restaurant?

    private var restaurantCollection = RestaurantCollection()
    var restaurants: [Restaurant] {
        Array(restaurantCollection.restaurants)
    }
    
    private init(customer: Customer) {
        self.customer = customer
        restaurantStorage = FBRestaurantStorage()
        restaurantStorage.logicDelegate = self
    }
    
    func fetchRestaurants() {
        restaurantStorage.loadAllRestaurants(completion: {
            if self.restaurantCollection.add($0) {
                self.searchDelegate?.restaurantCollectionDidLoadNewRestaurant()
            }
        })
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
            restaurantDelegate?.restaurantDidSetQueueStatus(toIsOpen: restaurant.isQueueOpen)
        }
        
        searchDelegate?.restaurantDidSetQueueStatus(restaurant: restaurant, toIsOpen: restaurant.isQueueOpen)
        
    }

    func didAddNewRestaurant(restaurant: Restaurant) {
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

extension RestaurantLogicManager {
    
    private static var restaurantLogic: RestaurantLogicManager?
    
    static func shared(for customerIdentity: Customer? = nil) -> RestaurantLogicManager {
        if let logic = restaurantLogic {
            return logic
        }
        
        assert(customerIdentity != nil,
               "Customer identity must be given non-nil to make the customer's restaurant logic manager.")
        let logic = RestaurantLogicManager(customer: customerIdentity!)
        logic.restaurantStorage.logicDelegate = logic
        
        restaurantLogic = logic
        return logic
    }
    
    static func deinitShared() {
        restaurantLogic = nil
    }
}

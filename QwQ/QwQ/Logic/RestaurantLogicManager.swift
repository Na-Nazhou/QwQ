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
    
    func restaurantDidOpenQueue(restaurant: Restaurant) {
        assert(restaurant.isQueueOpen,
               "Updated restaurant (passed in as argument) should be open.")
        assert(self.currentRestaurant != nil && self.currentRestaurant!.uid == restaurant.uid,
               "current restaurant should be the updated restaurant.")
        
        restaurantDelegate?.restaurantDidSetQueueStatus(toIsOpen: true)
        
        searchDelegate?.restaurantDidSetQueueStatus(restaurant: restaurant, toIsOpen: true)
        
    }
    
    func restaurantDidCloseQueue(restaurant: Restaurant) {
        assert(!restaurant.isQueueOpen,
               "Updated restaurant (passed in as argument) should be closed.")
        assert(self.currentRestaurant != nil && self.currentRestaurant!.uid == restaurant.uid,
               "current restaurant should be the updated restaurant.")
        
        restaurantDelegate?.restaurantDidSetQueueStatus(toIsOpen: false)
        
        searchDelegate?.restaurantDidSetQueueStatus(restaurant: restaurant, toIsOpen: false)
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

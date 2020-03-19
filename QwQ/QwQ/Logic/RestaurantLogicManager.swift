class RestaurantLogicManager: RestaurantLogic {

    // Storage
    private(set) var restaurantStorage: RestaurantStorage

    // View Controllers
    weak var restaurantDelegate: RestaurantDelegate?
    weak var searchDelegate: SearchDelegate?

    var customer: Customer
    var currentRestaurant: Restaurant?
    var restaurants = [Restaurant]()

    private init(customer: Customer) {
        self.customer = customer
        restaurantStorage = FBRestaurantStorage()
        restaurantStorage.logicDelegate = self
    }

    func fetchRestaurants() {
        restaurantStorage.loadAllRestaurants(completion: {
            self.restaurants = $0
        })
    }

    func restaurantDidOpenQueue(restaurant: Restaurant) {
        if let currentRestaurant = self.currentRestaurant,
            restaurant == currentRestaurant {
            self.currentRestaurant?.isOpen = true
            restaurantDelegate?.restaurantDidSetQueueStatus(toIsOpen: true)
        }

        searchDelegate?.restaurantDidSetQueueStatus(restaurant: restaurant, toIsOpen: true)

    }

    func restaurantDidCloseQueue(restaurant: Restaurant) {
        if let currentRestaurant = self.currentRestaurant,
            restaurant == currentRestaurant {
            self.currentRestaurant?.isOpen = false
            restaurantDelegate?.restaurantDidSetQueueStatus(toIsOpen: false)
        }

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

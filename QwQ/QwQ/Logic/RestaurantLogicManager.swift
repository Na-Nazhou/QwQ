class RestaurantLogicManager: RestaurantLogic {
    // Storage
    private(set) var restaurantStorage: RestaurantStorage

    // View Controllers
    weak var restaurantDelegate: RestaurantDelegate?
    weak var searchDelegate: SearchDelegate?

    private var customer: Customer
    var restaurants = [Restaurant]()

    private init(customer: Customer) {
        self.customer = customer
        restaurantStorage = RestaurantStorageStub()
        loadRestaurants()
    }

    private func loadRestaurants() {
        restaurants = restaurantStorage.loadAllRestaurants()
    }

    func restaurantDidOpenQueue(restaurant: Restaurant) {
    }

    func restaurantDidCloseQueue(restaurant: Restaurant) {
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
        return logic
    }

    static func deinitShared() {
        restaurantLogic = nil
    }
}

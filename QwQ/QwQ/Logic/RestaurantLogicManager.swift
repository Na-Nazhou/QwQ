class RestaurantLogicManager: RestaurantLogic {
    private(set) var restaurantStorage: RestaurantStorage

    private var customer: Customer
    weak var currentlyOpenRestaurantPage: RestaurantDelegate?
    var openRestaurants = [Restaurant]()

    func loadOpenRestaurants() {
    }

    func restaurantDidOpenQueue(restaurant: Restaurant) {
    }

    func restaurantDidCloseQueue(restaurant: Restaurant) {
    }
}

extension RestaurantLogicManager {

    private static var restaurantLogic: RestaurantLogicManager?

    static func shared(for customerIdentity: Customer?) -> RestaurantLogicManager {
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

    private init(customer: Customer) {
        self.customer = customer
        restaurantStorage = RestaurantStorageStub()
    }
}

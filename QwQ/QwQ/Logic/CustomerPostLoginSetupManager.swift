class CustomerPostLoginSetupManager {

    static func setUp(asIdentity customer: Customer) {
        _ = CustomerQueueLogicManager.shared(for: customer)
        _ = RestaurantLogicManager.shared(for: customer)
    }

    static func tearDown() {
        CustomerQueueLogicManager.deinitShared()
        RestaurantLogicManager.deinitShared()
    }

    static func customerDidUpdateProfile(updated: Customer) {
        CustomerQueueLogicManager.shared().customer = updated
        RestaurantLogicManager.shared().customer = updated
    }
}

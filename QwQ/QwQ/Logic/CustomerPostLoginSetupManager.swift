class CustomerPostLoginSetupManager {

    static func setUp(asIdentity customer: Customer) {
        _ = CustomerActivity.shared(for: customer)

        _ = RestaurantLogicManager.shared(for: customer)
    }

    static func tearDown() {
        CustomerActivity.deinitShared()

        RestaurantLogicManager.deinitShared()
    }

    static func customerDidUpdateProfile(updated: Customer) {
        CustomerActivity.shared().updateCustomer(updated)

        RestaurantLogicManager.shared().customer = updated
    }
}

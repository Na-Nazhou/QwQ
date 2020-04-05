class CustomerPostLoginSetupManager {
    static func setUp(asIdentity customer: Customer) {
        _ = CustomerActivity.shared(for: customer)
        FIRRestaurantStorage.shared.registerListener()
        FIRBookingStorage.shared.registerListener(for: customer)
        FIRQueueStorage.shared.registerListener(for: customer)
    }

    static func tearDown() {
        CustomerActivity.deinitShared()
        FIRRestaurantStorage.shared.removeListener()
        FIRBookingStorage.shared.removeListener()
        FIRQueueStorage.shared.removeListener()
    }

    static func customerDidUpdateProfile(updated: Customer) {
        CustomerActivity.shared().updateCustomer(updated)
    }
}

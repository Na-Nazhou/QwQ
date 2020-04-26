/// A shared resource setup manager.
class CustomerPostLoginSetupManager {
    /// Sets up the shared storage singletons and `CustomerActivity` resource for `customer`.
    static func setUp(asIdentity customer: Customer) {
        _ = CustomerActivity.shared(for: customer)
        FIRRestaurantStorage.shared.registerListener()
        FIRBookingStorage.shared.registerListener(for: customer)
        FIRQueueStorage.shared.registerListener(for: customer)
    }
    
    /// Clears the shared resources.
    static func tearDown() {
        CustomerActivity.deinitShared()
        FIRRestaurantStorage.shared.removeListener()
        FIRBookingStorage.shared.removeListener()
        FIRQueueStorage.shared.removeListener()
    }

    /// Updates the shared customer identity resource with `updated`.
    static func customerDidUpdateProfile(updated: Customer) {
        CustomerActivity.shared().updateCustomer(updated)
    }
}

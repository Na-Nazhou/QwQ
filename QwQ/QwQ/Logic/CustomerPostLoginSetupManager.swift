class CustomerPostLoginSetupManager {
    static func setUp(asIdentity customer: Customer) {
        _ = CustomerActivity.shared(for: customer)
        FBBookingStorage.shared.registerListener(for: customer)
    }

    static func tearDown() {
        CustomerActivity.deinitShared()
        FBBookingStorage.shared.removeListener()
    }

    static func customerDidUpdateProfile(updated: Customer) {
        CustomerActivity.shared().updateCustomer(updated)
    }
}

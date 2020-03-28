class CustomerPostLoginSetupManager {

    static func setUp(asIdentity customer: Customer) {
        _ = CustomerActivity.shared(for: customer)
    }

    static func tearDown() {
        CustomerActivity.deinitShared()
    }

    static func customerDidUpdateProfile(updated: Customer) {
        CustomerActivity.shared().updateCustomer(updated)
    }
}

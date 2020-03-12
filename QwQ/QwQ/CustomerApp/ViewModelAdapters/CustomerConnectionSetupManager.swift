class CustomerConnectionSetupManager {
    init(asIdentity customer: Customer) {
        _ = CustomerQueueLogicManager.shared(for: customer)
        _ = RestaurantLogicManager.shared(for: customer)
    }
}

class CustomerPostLoginSetupManager {
    static func setUp(asIdentity customer: Customer) {
        let queueStorage = FBQueueStorage()
        let bookingStorage = FBBookingStorage()
        _ = CustomerQueueLogicManager.shared(for: customer, with: queueStorage)
        _ = CustomerBookingLogicManager.shared(for: customer, with: bookingStorage)
        _ = CustomerHistoryLogicManager.shared(for: customer,
                                               queueStorage: queueStorage,
                                               bookingStorage: bookingStorage)
        _ = RestaurantLogicManager.shared(for: customer)
    }

    static func tearDown() {
        CustomerQueueLogicManager.deinitShared()
        CustomerBookingLogicManager.deinitShared()
        CustomerHistoryLogicManager.deinitShared()
        RestaurantLogicManager.deinitShared()
    }

    static func customerDidUpdateProfile(updated: Customer) {
        CustomerQueueLogicManager.shared().customer = updated
        CustomerBookingLogicManager.shared().customer = updated
        CustomerHistoryLogicManager.shared().customer = updated
        RestaurantLogicManager.shared().customer = updated
    }
}

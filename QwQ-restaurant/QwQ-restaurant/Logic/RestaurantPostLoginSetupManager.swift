/// A shared resource setup manager.
class RestaurantPostLoginSetupManager {
    /// Sets up the shared storage singletons and `RestaurantActivity` resource for `restaurant`.
    static func setUp(asIdentity restaurant: Restaurant) {
        FIRQueueStorage.shared.registerListener(for: restaurant)
        FIRBookingStorage.shared.registerListener(for: restaurant)
        FIRRestaurantStorage.registerListener(for: restaurant)
        _ = RestaurantActivity.shared(for: restaurant)
    }

    /// Clears the shared resources.
    static func tearDown() {
        FIRQueueStorage.shared.removeListener()
        FIRBookingStorage.shared.removeListener()
        FIRRestaurantStorage.removeListener()
        RestaurantActivity.deinitShared()
    }
}

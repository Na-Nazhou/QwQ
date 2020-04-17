/// Provides methods to setup connection to queue/booking logic and storage components.
class RestaurantPostLoginSetupManager {
    static func setUp(asIdentity restaurant: Restaurant) {
        FIRQueueStorage.shared.registerListener(for: restaurant)
        FIRBookingStorage.shared.registerListener(for: restaurant)
        FIRRestaurantStorage.registerListener(for: restaurant)
        _ = RestaurantActivity.shared(for: restaurant)
    }

    static func tearDown() {
        FIRQueueStorage.shared.removeListener()
        FIRBookingStorage.shared.removeListener()
        FIRRestaurantStorage.removeListener()
        RestaurantActivity.deinitShared()
    }
}

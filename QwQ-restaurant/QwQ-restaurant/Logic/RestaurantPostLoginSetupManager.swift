/// Provides methods to setup connection to queue/booking logic and storage components.
class RestaurantPostLoginSetupManager {
    static func setUp(asIdentity restaurant: Restaurant) {
        FIRQueueStorage.shared.registerListeners(for: restaurant)
        FIRBookingStorage.shared.registerListener(for: restaurant)
        _ = RestaurantActivity.shared(for: restaurant)
    }

    static func tearDown() {
        FIRQueueStorage.shared.removeListeners()
        FIRBookingStorage.shared.removeListener()
        RestaurantActivity.deinitShared()
    }

    static func restaurantDidUpdateProfile(updated: Restaurant) {
        RestaurantActivity.shared().updateRestaurant(updated)
    }
}

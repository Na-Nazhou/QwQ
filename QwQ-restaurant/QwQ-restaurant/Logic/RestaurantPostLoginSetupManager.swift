/// Provides methods to setup connection to queue/booking logic and storage components.
class RestaurantPostLoginSetupManager {
    static func setUp(asIdentity restaurant: Restaurant) {
        FBQueueStorage.shared.registerListeners(for: restaurant)
        FBBookingStorage.shared.registerListener(for: restaurant)
        _ = RestaurantRecordLogicManager.shared(for: restaurant)
    }

    static func tearDown() {
        RestaurantRecordLogicManager.deinitShared()
        FBQueueStorage.shared.removeListeners()
        FBBookingStorage.shared.removeListener()
    }
}

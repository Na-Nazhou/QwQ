/// Provides methods to setup connection to queue/booking logic and storage components.
class RestaurantPostLoginSetupManager {
    static func setUp(asIdentity restaurant: Restaurant) {
        FIRQueueStorage.shared.registerListeners(for: restaurant)
        FIRBookingStorage.shared.registerListener(for: restaurant)
        _ = RestaurantRecordLogicManager.shared(for: restaurant)
    }

    static func tearDown() {
        RestaurantRecordLogicManager.deinitShared()
        FIRQueueStorage.shared.removeListeners()
        FIRBookingStorage.shared.removeListener()
    }
}

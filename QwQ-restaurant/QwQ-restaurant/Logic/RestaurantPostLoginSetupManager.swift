/// Provides methods to setup connection to queue/booking logic and storage components.
class RestaurantPostLoginSetupManager {
    static func setUp(asIdentity restaurant: Restaurant) {
        _ = RestaurantRecordLogicManager.shared(for: restaurant)
    }

    static func tearDown() {
        RestaurantRecordLogicManager.deinitShared()
    }
}

/// Provides methods to setup connection to queue/booking logic and storage components.
class RestaurantPostLoginSetupManager {
    static func setUp(asIdentity restaurant: Restaurant) {
        _ = RestaurantQueueLogicManager.shared(for: restaurant)
    }

    static func tearDown() {
        RestaurantQueueLogicManager.deinitShared()
    }
}

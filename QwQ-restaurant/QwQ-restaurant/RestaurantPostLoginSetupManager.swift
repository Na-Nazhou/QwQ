/// Provides methods to setup connection to queue/booking logic and storage components.
class RestaurantPostLoginSetupManager {
    init(asIdentity restaurant: Restaurant) {
        _ = RestaurantQueueLogicManager.shared(for: restaurant)
    }
}

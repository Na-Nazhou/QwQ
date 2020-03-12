/// Represents the protocol needed to sync restaurant pages on customer's end.
protocol RestaurantStorageSyncDelegate: AnyObject {
    func restaurantDidOpenQueue(restaurant: Restaurant)
    func restaurantDidCloseQueue(restaurant: Restaurant)
}

protocol RestaurantStorageSync: QueueOpenCloseSyncDelegate {
    var logicDelegate: RestaurantStorageSyncDelegate? { get set }
}

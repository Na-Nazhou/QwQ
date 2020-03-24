protocol RestaurantStorageSync {
    var logicDelegate: RestaurantStorageSyncDelegate? { get set }
}

protocol RestaurantStorage: RestaurantStorageSync {
    // MARK: - Query
    /// Return all the restaurants.
    func loadAllRestaurants(completion: @escaping (Restaurant) -> Void)
}

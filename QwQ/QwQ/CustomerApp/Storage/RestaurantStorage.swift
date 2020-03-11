protocol RestaurantStorage {
    // MARK: - Query
    /// Return all the currently open restaurants
    func loadOpenRestaurants() -> [Restaurant]
}

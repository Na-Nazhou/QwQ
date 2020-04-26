/// Represents the protocol a synchronizable storage component should conform to to store restaurants.
protocol RestaurantStorageSync {

    // MARK: - Delegates
    /// Register `del` as a delegate of this component.
    func registerDelegate(_ del: RestaurantStorageSyncDelegate)
    
    /// Unregister `del` from this component.
    func unregisterDelegate(_ del: RestaurantStorageSyncDelegate)
}

/// Represents a storage component for storing restaurants.
protocol RestaurantStorage: RestaurantStorageSync {

}

import Foundation

protocol RestaurantStorageSync {

    // MARK: - Delegates
    func registerDelegate(_ del: RestaurantStorageSyncDelegate)

    func unregisterDelegate(_ del: RestaurantStorageSyncDelegate)
}

protocol RestaurantStorage: RestaurantStorageSync {

}

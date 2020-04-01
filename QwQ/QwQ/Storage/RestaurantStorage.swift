import Foundation

protocol RestaurantStorageSync {
    var logicDelegates: NSHashTable<AnyObject> { get }

    func registerDelegate(_ del: RestaurantStorageSyncDelegate)

    func unregisterDelegate(_ del: RestaurantStorageSyncDelegate)
}

protocol RestaurantStorage: RestaurantStorageSync {

}

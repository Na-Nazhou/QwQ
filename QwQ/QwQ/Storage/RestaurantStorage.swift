protocol RestaurantStorageSync {
    var logicDelegate: RestaurantStorageSyncDelegate? { get set }
}

protocol RestaurantStorage: RestaurantStorageSync {

}

class RestaurantQueueStorageStub: RestaurantQueueStorage, QueueStorageSync {
    weak var logicDelegate: RestaurantQueueStorageSyncDelegate?

    func loadQueue() {
    }

    func openQueue() {
    }

    func closeQueue() {
    }

    func admitCustomer(record: RestaurantQueueRecord) {
    }

    func didAddQueueRecord(record: RestaurantQueueRecord) {
    }

    func didUpdateQueueRecord(old: RestaurantQueueRecord, new: RestaurantQueueRecord) {
    }

    func didDeleteQueueRecord(record: RestaurantQueueRecord) {
    }
}

protocol RestaurantQueueStorage {
    // MARK: - Modifier
    func openQueue()
    func closeQueue()
    func admitCustomer(record: RestaurantQueueRecord)

    // MARK: - Query
    func loadQueue()
}

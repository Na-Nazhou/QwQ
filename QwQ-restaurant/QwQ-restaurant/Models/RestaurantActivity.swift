class RestaurantActivity {
    // MARK: Restaurant as singleton
    private static var restaurantActivity: RestaurantActivity?

    static func shared(for restaurant: Restaurant? = nil) -> RestaurantActivity {
        if let activity = restaurantActivity {
            return activity
        }
        assert(restaurant != nil, "Restaurant identity must be given non-nil for it to have an activity.")
        let activity = RestaurantActivity(restaurant: restaurant!)
        restaurantActivity = activity
        return activity
    }

    static func deinitShared() {
        restaurantActivity = nil
    }

    // MARK: Properties
    private(set) var restaurant: Restaurant

    var currentQueue: RecordCollection<QueueRecord>
    var waitingQueue: RecordCollection<QueueRecord>
    var historyQueue: RecordCollection<QueueRecord>

    var currentBookings: RecordCollection<BookRecord>
    var waitingBookings: RecordCollection<BookRecord>
    var historyBookings: RecordCollection<BookRecord>

    var historyRecords: [Record] {
        var records = [Record]()
        records.append(contentsOf: historyQueue.records)
        records.append(contentsOf: historyBookings.records)
        return records
    }

    private init(restaurant: Restaurant) {
        self.restaurant = restaurant
        currentQueue = RecordCollection<QueueRecord>()
        currentBookings = RecordCollection<BookRecord>()
        historyQueue = RecordCollection<QueueRecord>()
        historyBookings = RecordCollection<BookRecord>()
        waitingQueue = RecordCollection<QueueRecord>()
        waitingBookings = RecordCollection<BookRecord>()
    }
}

extension RestaurantActivity {
    func updateRestaurant(_ updated: Restaurant) {
        assert(restaurant == updated, "Restaurant id should be the same to update.")
        restaurant = updated
    }
}

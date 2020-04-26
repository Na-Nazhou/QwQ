/// A model of the restaurant activity.
class RestaurantActivity {
    // MARK: Restaurant as singleton shared resource
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

    let currentQueue = RecordCollection<QueueRecord>()
    let waitingQueue = RecordCollection<QueueRecord>()
    let historyQueue = RecordCollection<QueueRecord>()

    let currentBookings = RecordCollection<BookRecord>()
    let waitingBookings = RecordCollection<BookRecord>()
    let historyBookings = RecordCollection<BookRecord>()

    var currentRecords: [Record] {
        currentQueue.records + currentBookings.records
    }

    var waitingRecords: [Record] {
        waitingQueue.records + waitingBookings.records
    }

    var historyRecords: [Record] {
        historyQueue.records + historyBookings.records
    }

    private init(restaurant: Restaurant) {
        self.restaurant = restaurant
    }
}

extension RestaurantActivity {
    func updateRestaurant(_ updated: Restaurant) {
        assert(restaurant == updated, "Restaurant id should be the same to update.")
        restaurant = updated
    }
}

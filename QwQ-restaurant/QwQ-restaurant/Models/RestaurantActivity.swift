import Foundation

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

    let currentQueue = RecordCollection<QueueRecord>()
    let waitingQueue = RecordCollection<QueueRecord>()
    let historyQueue = RecordCollection<QueueRecord>()

    let currentBookings = RecordCollection<BookRecord>()
    let waitingBookings = RecordCollection<BookRecord>()
    let historyBookings = RecordCollection<BookRecord>()

    var currentRecords: [Record] {
        let bookRecords = currentQueue.records
        let queueRecords = currentBookings.records
        return (bookRecords + queueRecords).sorted(by: { record1, record2 in
            let time1: Date
            let time2: Date
            if let queueRecord1 = record1 as? QueueRecord {
                time1 = queueRecord1.startTime
            } else {
                time1 = (record1 as? BookRecord)!.time
            }
            if let queueRecord2 = record2 as? QueueRecord {
                time2 = queueRecord2.startTime
            } else {
                time2 = (record2 as? BookRecord)!.time
            }
            return time1 < time2
        })
    }

    var waitingRecords: [Record] {
        let bookRecords = waitingQueue.records
        let queueRecords = waitingBookings.records
        return (bookRecords + queueRecords).sorted(by: { record1, record2 in
            record1.admitTime! < record2.admitTime!
        })
    }

    var historyRecords: [Record] {
        let bookRecords = historyQueue.records
        let queueRecords = historyBookings.records
        return (bookRecords + queueRecords).sorted(by: { record1, record2 in
            let time1: Date
            let time2: Date
            if record1.isServed {
                time1 = record1.serveTime!
            } else if record1.isRejected {
                time1 = record1.rejectTime!
            } else {
                time1 = record1.withdrawTime!
            }
            if record2.isServed {
                time2 = record2.serveTime!
            } else if record2.isRejected {
                time2 = record2.rejectTime!
            } else {
                time2 = record2.withdrawTime!
            }
            return time1 > time2
        })
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

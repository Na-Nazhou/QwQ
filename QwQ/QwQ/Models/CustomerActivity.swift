import Foundation

/// A model of customer activity.
class CustomerActivity {
    // MARK: Customer as singleton shared resource
    private static var customerActivity: CustomerActivity?

    static func shared(for customer: Customer? = nil) -> CustomerActivity {
        if let activity = customerActivity {
            return activity
        }
        assert(customer != nil, "Customer identity must be given non-nil for it to have an activity.")
        let activity = CustomerActivity(customer: customer!)
        customerActivity = activity
        return activity
    }

    static func deinitShared() {
        customerActivity = nil
    }

    // MARK: Properties
    private(set) var customer: Customer

    let currentQueues = RecordCollection<QueueRecord>()
    let currentBookings = RecordCollection<BookRecord>()
    let missedQueues = RecordCollection<QueueRecord>()
    let queueHistory = RecordCollection<QueueRecord>()
    let bookingHistory = RecordCollection<BookRecord>()

    var activeRecords: [Record] {
        currentQueues.records + currentBookings.records
    }

    var historyRecords: [Record] {
        queueHistory.records + bookingHistory.records
    }

    var missedRecords: [Record] {
        missedQueues.records
    }

    var queueRecords: [QueueRecord] {
        currentQueues.records + queueHistory.records + missedQueues.records
    }

    var bookRecords: [BookRecord] {
        currentBookings.records + bookingHistory.records
    }

    private init(customer: Customer) {
        self.customer = customer
    }
}

extension CustomerActivity {
    func updateCustomer(_ updated: Customer) {
        assert(customer == updated, "Customer id should be the same to update.")
        customer = updated
    }
}

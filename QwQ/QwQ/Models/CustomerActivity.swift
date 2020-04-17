class CustomerActivity {
    // MARK: Customer as singleton
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
    let queueHistory = RecordCollection<QueueRecord>()
    let bookingHistory = RecordCollection<BookRecord>()

    var activeRecords: [Record] {
        currentQueues.records + currentBookings.records
    }

    var historyRecords: [Record] {
        queueHistory.records + bookingHistory.records
    }

    var queueRecords: [QueueRecord] {
        currentQueues.records + queueHistory.records
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

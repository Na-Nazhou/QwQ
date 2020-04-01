class CustomerActivity {
    // MARK: Customer as singleton
    private static var customerActivity: CustomerActivity?

    static func shared(for customer: Customer? = nil) -> CustomerActivity {
        if let activity = customerActivity {
            return activity
        }
        assert(customer != nil, "Customer identity must be given non-nil for it to have a history.")
        let activity = CustomerActivity(customer: customer!)
        customerActivity = activity
        return activity
    }

    static func deinitShared() {
        customerActivity = nil
    }

    // MARK: Properties
    private(set) var customer: Customer

    var currentQueues: RecordCollection<QueueRecord>
    var currentBookings: RecordCollection<BookRecord>

    var queueHistory: RecordCollection<QueueRecord>
    var bookingHistory: RecordCollection<BookRecord>

    var historyRecords: [Record] {
        var records = [Record]()
        records.append(contentsOf: queueHistory.records)
        records.append(contentsOf: bookingHistory.records)
        return records
    }

    private init(customer: Customer) {
        self.customer = customer
        currentQueues = RecordCollection<QueueRecord>()
        currentBookings = RecordCollection<BookRecord>()
        queueHistory = RecordCollection<QueueRecord>()
        bookingHistory = RecordCollection<BookRecord>()
    }
}

extension CustomerActivity {
    func updateCustomer(_ updated: Customer) {
        assert(customer == updated, "Customer id should be the same to update.")
        customer = updated
    }
}
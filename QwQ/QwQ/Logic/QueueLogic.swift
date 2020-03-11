/// Represents the queue protocol needed to sync when storage notifies of any changes.
protocol QueueStorageSyncDelegate {
    
}

/// Represents the entire queue logic protocol needed for the application.
protocol QueueLogic: QueueStorageSyncDelegate {
    
    /// Creates queue record for customer and updates database.
    /// Returns a error message if fails to queue, i.e. restaurant stopped queueing functionality, or storage error.
    func enqueue(customer: Customer, to restaurant: Restaurant, with groupSize: Int, babyCount: Int, wheelchairCount: Int) -> String?
    
    /// Updates time served (for stats; automatically considered nonactive).
    func dequeueAndNotify()
    
    /// Use case: 5min before, on time
    func notify()

    func update
    
}

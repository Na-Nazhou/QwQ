/// Represents the protocol a restaurant statistics storage retrieval component should conform to.
protocol RestaurantStatsStorage {

    /// Fetch total number of customers for `restaurant` and perform `completion` on the retrieved statitic.
    func fetchTotalNumCustomers(for restaurant: Restaurant,
                                stats: Statistics,
                                completion: @escaping (Int) -> Void)
    
    /// Fetch total waiting time for customers for `restaurant` and perform `completion` on the retrieved statitic.
    /// Waiting time for customers refer to the time customers have to wait to be admitted.
    func fetchTotalWaitingTimeForCustomer(for restaurant: Restaurant,
                                          stats: Statistics,
                                          completion: @escaping (Int) -> Void)
    
    /// Fetch total waiting time for `restaurant` and perform `completion` on the retrieved statitic.
    /// Waiting time for restaurants refer to the time restaurants have to wait for customers to turn up.
    func fetchTotalWaitingTimeForRestaurant(for restaurant: Restaurant,
                                            stats: Statistics,
                                            completion: @escaping (Int) -> Void)
    
    /// Fetch queue cancellation rate for `restaurant` and perform `completion` on the retrieved statitic.
    func fetchQueueCancellationRate(for restaurant: Restaurant,
                                    stats: Statistics,
                                    completion: @escaping (Int, Int) -> Void)
    
    /// Fetch booking cancellation rate for `restaurant` and perform `completion` on the retrieved statitic.
    func fetchBookingCancellationRate(for restaurant: Restaurant,
                                      stats: Statistics,
                                      completion: @escaping (Int, Int) -> Void)
}

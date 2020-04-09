import Foundation

protocol RestaurantStatsStorage {

    func fetchTotalNumCustomers(for restaurant: Restaurant,
                                from date: Date, to date2: Date,
                                completion: @escaping (Int) -> Void)

    /// Average time for restaurants to wait for customer to accept? reach and be served?
    func fetchTotalWaitingTimeForCustomer(for restaurant: Restaurant,
                                          from date: Date, to date2: Date,
                                          completion: @escaping (Int) -> Void)

    func fetchTotalWaitingTimeForRestaurant(for restaurant: Restaurant,
                                            from date: Date, to date2: Date,
                                            completion: @escaping (Int) -> Void)

    func fetchQueueCancellationRate(for restaurant: Restaurant,
                                    from date: Date, to date2: Date,
                                    completion: @escaping (Int) -> Void)

    func fetchBookingCancellationRate(for restaurant: Restaurant,
                                      from date: Date, to date2: Date,
                                      completion: @escaping (Int) -> Void)
}

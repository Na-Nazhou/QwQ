protocol RestaurantStatsStorage {

    func fetchTotalNumCustomers(for restaurant: Restaurant,
                                stats: Statistics,
                                completion: @escaping (Int) -> Void)

    func fetchTotalWaitingTimeForCustomer(for restaurant: Restaurant,
                                          stats: Statistics,
                                          completion: @escaping (Int) -> Void)

    func fetchTotalWaitingTimeForRestaurant(for restaurant: Restaurant,
                                            stats: Statistics,
                                            completion: @escaping (Int) -> Void)

    func fetchQueueCancellationRate(for restaurant: Restaurant,
                                    stats: Statistics,
                                    completion: @escaping (Int, Int) -> Void)

    func fetchBookingCancellationRate(for restaurant: Restaurant,
                                      stats: Statistics,
                                      completion: @escaping (Int, Int) -> Void)
}

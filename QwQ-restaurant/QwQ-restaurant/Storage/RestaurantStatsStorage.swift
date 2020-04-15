import Foundation

protocol RestaurantStatsStorage {

    func fetchTotalNumCustomers(for restaurant: Restaurant,
                                from date1: Date, to date2: Date,
                                completion: @escaping (Int) -> Void)

    func fetchTotalWaitingTimeForCustomer(for restaurant: Restaurant,
                                          from date1: Date, to date2: Date,
                                          completion: @escaping (Int) -> Void)

    func fetchTotalWaitingTimeForRestaurant(for restaurant: Restaurant,
                                            from date1: Date, to date2: Date,
                                            completion: @escaping (Int) -> Void)

    func fetchQueueCancellationRate(for restaurant: Restaurant,
                                    from date1: Date, to date2: Date,
                                    completion: @escaping (Int, Int) -> Void)

    func fetchBookingCancellationRate(for restaurant: Restaurant,
                                      from date1: Date, to date2: Date,
                                      completion: @escaping (Int, Int) -> Void)
}

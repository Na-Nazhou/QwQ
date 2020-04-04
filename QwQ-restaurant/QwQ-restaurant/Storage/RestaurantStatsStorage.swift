import Foundation

protocol RestaurantStatsStorage {

    func fetchTotalNumCustomers(for restaurant: Restaurant, from date: Date, to date2: Date, completion: (Int) -> Void)
    /// Average time for restaurants to wait for customer to accept? reach and be served?
    func fetchTotalWaitingTimeForCustomer(for restaurant: Restaurant, from date: Date, to date2: Date, completion: (Int) -> Void)
    func fetchTotalWaitingTimeForRestaurant(for restaurant: Restaurant, from date: Date, to date2: Date, completion: (Int) -> Void)
    func fetchQueueCancellationRate(for restaurant: Restaurant, from date: Date, to date2: Date, completion: (Int) -> Void)
    func fetchBookingCancellationRate(for restaurant: Restaurant, from date: Date, to date2: Date, completion: (Int) -> Void)
}

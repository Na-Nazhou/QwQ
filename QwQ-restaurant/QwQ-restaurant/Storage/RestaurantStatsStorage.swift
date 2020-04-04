import Foundation

protocol RestaurantStatsStorage {

    func totalNumCustomers(for restaurant: Restaurant, from date: Date, to date2: Date, completion: (Int) -> Void)
    /// Average time for restaurants to wait for customer to accept? reach and be served?
    func avgWaitingTimeForCustomer(for restaurant: Restaurant, from date: Date, to date2: Date, completion: (Int) -> Void)
    func queueCancellationRate(for restaurant: Restaurant, from date: Date, to date2: Date, completion: (Int) -> Void)
    func bookingCancellationRate(for restaurant: Restaurant, from date: Date, to date2: Date, completion: (Int) -> Void)
}

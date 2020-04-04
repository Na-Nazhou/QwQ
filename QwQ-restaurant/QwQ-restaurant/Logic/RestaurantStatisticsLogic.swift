import Foundation
protocol RestaurantStatisticsLogic {
    var statsDelegate: StatsPresentationDelegate? { get set }

    func loadAllStats(from date: Date, to date2: Date)

    func fetchTotalNumCustomers(from date: Date, to date2: Date)
    /// Average time for restaurants to wait for customer to accept? reach and be served?
    func fetchAvgWaitingTimeForCustomer(from date: Date, to date2: Date)
    func fetchQueueCancellationRate(from date: Date, to date2: Date)
    func fetchBookingCancellationRate(from date: Date, to date2: Date)
}

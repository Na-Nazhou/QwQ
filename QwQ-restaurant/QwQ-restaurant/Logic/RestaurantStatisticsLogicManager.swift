import Foundation

class RestaurantStatisticsLogicManager: RestaurantStatisticsLogic {

    // Storage
    private let storage: RestaurantStatsStorage

    // View Controller
    weak var statsDelegate: StatsPresentationDelegate?

    // Models
    private let restaurantActivity: RestaurantActivity
    var restaurant: Restaurant {
        restaurantActivity.restaurant
    }

    var dailyDetails = [Statistics]()
    var weeklyDetails = [Statistics]()
    var monthlyDetails = [Statistics]()

    convenience init() {
        self.init(storage: FIRStatsStorage.shared,
                  restaurantActivity: RestaurantActivity.shared())
    }

    init(storage: RestaurantStatsStorage, restaurantActivity: RestaurantActivity) {
        self.storage = storage
        self.restaurantActivity = restaurantActivity
    }

    func fetchDailyDetails() {
        dailyDetails.removeAll()
        let tenDaysAgo = Date().getDateOf(daysBeforeDate: 10)
        for i  in (0..<10).reversed() {
            let fromDate = Calendar.current.date(byAdding: .day, value: i, to: tenDaysAgo)!
            let toDate = Calendar.current.date(byAdding: .day, value: i + 1, to: tenDaysAgo)!
            let stats = loadStats(from: fromDate, to: toDate)
            dailyDetails.append(stats)
        }
        statsDelegate?.didCompleteFetchingData()
    }

    func fetchWeeklyDetails() {
        weeklyDetails.removeAll()
        let tenWeeksAgo = Calendar.current.date(byAdding: .weekOfMonth, value: -10, to: Date())!
        for i  in (0..<10).reversed() {
            let fromDate = Calendar.current.date(byAdding: .weekOfMonth, value: i, to: tenWeeksAgo)!
            let toDate = Calendar.current.date(byAdding: .weekOfMonth, value: i + 1, to: tenWeeksAgo)!
            let stats = loadStats(from: fromDate, to: toDate)
            weeklyDetails.append(stats)
        }
        statsDelegate?.didCompleteFetchingData()
    }

    func fetchMonthlyDetails() {
        monthlyDetails.removeAll()
        let oneYearAgo = Calendar.current.date(byAdding: .month, value: -12, to: Date())!
        for i  in (0..<12).reversed() {
            let fromDate = Calendar.current.date(byAdding: .month, value: i, to: oneYearAgo)!
            let toDate = Calendar.current.date(byAdding: .month, value: i + 1, to: oneYearAgo)!
            let stats = loadStats(from: fromDate, to: toDate)
            monthlyDetails.append(stats)
        }
        statsDelegate?.didCompleteFetchingData()
    }

    private func loadStats(from date1: Date, to date2: Date) -> Statistics {
        let stats = Statistics(fromDate: date1, toDate: date2)
        fetchTotalNumCustomers(for: stats)
        fetchAvgWaitingTimeForCustomer(for: stats)
        fetchAvgWaitingTimeForRestaurant(for: stats)
        fetchQueueCancellationRate(for: stats)
        fetchBookingCancellationRate(for: stats)
        return stats
    }

    func fetchTotalNumCustomers(for stats: Statistics) {
        storage.fetchTotalNumCustomers(for: restaurant, from: stats.fromDate, to: stats.toDate) { count in
            stats.totalNumCustomers += count
            self.statsDelegate?.didCompleteFetchingData()
        }
    }

    func fetchAvgWaitingTimeForCustomer(for stats: Statistics) {
        storage.fetchTotalWaitingTimeForCustomer(for: restaurant, from: stats.fromDate, to: stats.toDate) { seconds in
            stats.totalWaitingTimeCustomerPOV = seconds
            self.statsDelegate?.didCompleteFetchingData()
        }
    }

    func fetchAvgWaitingTimeForRestaurant(for stats: Statistics) {
        storage.fetchTotalWaitingTimeForRestaurant(for: restaurant, from: stats.fromDate, to: stats.toDate) { seconds in
            stats.totalWaitingTimeRestaurantPOV = seconds
            self.statsDelegate?.didCompleteFetchingData()
        }
    }

    func fetchQueueCancellationRate(for stats: Statistics) {
        storage.fetchQueueCancellationRate(for: restaurant,  from: stats.fromDate, to: stats.toDate) { count in
            stats.totalQueueCancelled = count
            self.statsDelegate?.didCompleteFetchingData()
        }
    }

    func fetchBookingCancellationRate(for stats: Statistics) {
        storage.fetchBookingCancellationRate(for: restaurant, from: stats.fromDate, to: stats.toDate) { count in
            stats.totalBookingCancelled = count
            self.statsDelegate?.didCompleteFetchingData()
        }
    }
}

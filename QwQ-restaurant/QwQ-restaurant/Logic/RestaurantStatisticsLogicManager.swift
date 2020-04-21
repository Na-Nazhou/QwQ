import Foundation

class RestaurantStatisticsLogicManager: RestaurantStatisticsLogic {

    // Storage
    private let statsStorage: RestaurantStatsStorage

    // View Controller
    weak var statsDelegate: StatsDelegate?
    weak var statsDetailsDelegate: StatsDetailsDelegate?

    // Models
    private let restaurantActivity: RestaurantActivity
    private var restaurant: Restaurant {
        restaurantActivity.restaurant
    }

    var currentStats: Statistics?

    private let dailyStatsCollection = Collection<Statistics>()
    var dailyDetails: [Statistics] {
        dailyStatsCollection.statistics
    }

    private let weeklyStatsCollection = Collection<Statistics>()
    var weeklyDetails: [Statistics] {
        weeklyStatsCollection.statistics
    }

    private let monthlyStatsCollection = Collection<Statistics>()
    var monthlyDetails: [Statistics] {
        monthlyStatsCollection.statistics
    }

    private(set) var dailySummary: Statistics?
    private(set) var weeklySummary: Statistics?
    private(set) var monthlySummary: Statistics?

    convenience init() {
        self.init(statsStorage: FIRStatsStorage.shared,
                  restaurantActivity: RestaurantActivity.shared())
    }

    init(statsStorage: RestaurantStatsStorage, restaurantActivity: RestaurantActivity) {
        self.restaurantActivity = restaurantActivity
        self.statsStorage = statsStorage
    }

    func fetchDailyDetails() {
        let today = Date()
        for i in 0..<10 {
            let fromDate = Calendar.current.date(byAdding: .day, value: -i, to: today)!
            let toDate = Calendar.current.date(byAdding: .day, value: -i, to: today)!
            let stats = loadStats(from: fromDate, to: toDate)
            dailyStatsCollection.addOrUpdate(stats)
        }
    }

    func fetchWeeklyDetails() {
        let currentWeek = Date.getMonday(of: Date())
        for i in 0..<10 {
            let fromDate = Calendar.current.date(byAdding: .weekOfMonth, value: -i, to: currentWeek)!
            let temp = Calendar.current.date(byAdding: .weekOfMonth, value: -i + 1, to: currentWeek)!
            let toDate = Calendar.current.date(byAdding: .day, value: -1, to: temp)!
            let stats = loadStats(from: fromDate, to: toDate)
            weeklyStatsCollection.addOrUpdate(stats)
        }
    }

    func fetchMonthlyDetails() {
        let currentYear = Calendar.current.component(.year, from: Date())
        let currentMonth = Calendar.current.component(.month, from: Date())
        let firstDayOfMonth = Calendar.current.date(
            from: DateComponents(year: currentYear, month: currentMonth, day: 1))!
        for i in 0..<12 {
            let fromDate = Calendar.current.date(byAdding: .month, value: -i, to: firstDayOfMonth)!
            let temp = Calendar.current.date(byAdding: .month, value: -i + 1, to: firstDayOfMonth)!
            let toDate = Calendar.current.date(byAdding: .day, value: -1, to: temp)!
            let stats = loadStats(from: fromDate, to: toDate)
            monthlyStatsCollection.addOrUpdate(stats)
        }
    }

    func fetchSummary(type: StatsType) {
        var fromDate: Date?
        var toDate: Date?
        switch type {
        case .daily:
            fromDate = dailyStatsCollection.fromDate
            toDate = dailyStatsCollection.toDate
            guard let from = fromDate, let to = toDate else {
                return
            }
            dailySummary = loadStats(from: from, to: to)
        case .weekly:
            fromDate = weeklyStatsCollection.fromDate
            toDate = weeklyStatsCollection.toDate
            guard let from = fromDate, let to = toDate else {
                return
            }
            weeklySummary = loadStats(from: from, to: to)
        case .monthly:
            fromDate = monthlyStatsCollection.fromDate
            toDate = monthlyStatsCollection.toDate
            guard let from = fromDate, let to = toDate else {
                return
            }
            monthlySummary = loadStats(from: from, to: to)
        }
    }

    func loadStats(from date1: Date, to date2: Date) -> Statistics {
        let stats = Statistics(fromDate: date1, toDate: date2)
        fetchTotalNumCustomers(for: stats)
        fetchAvgWaitingTimeForCustomer(for: stats)
        fetchAvgWaitingTimeForRestaurant(for: stats)
        fetchQueueCancellationRate(for: stats)
        fetchBookingCancellationRate(for: stats)
        return stats
    }

    private func fetchTotalNumCustomers(for stats: Statistics) {
        statsStorage.fetchTotalNumCustomers(for: restaurant, stats: stats) { count in
            stats.totalNumOfCustomers += count
            self.statsDelegate?.didCompleteFetchingData()
            if stats == self.currentStats {
                self.statsDetailsDelegate?.didCompleteFetchingData()
            }
        }
    }

    private func fetchAvgWaitingTimeForCustomer(for stats: Statistics) {
        statsStorage.fetchTotalWaitingTimeForCustomer(for: restaurant, stats: stats) { seconds in
            stats.totalWaitingTimeCustomerPOV = seconds
            self.statsDelegate?.didCompleteFetchingData()
            if stats == self.currentStats {
                self.statsDetailsDelegate?.didCompleteFetchingData()
            }
        }
    }

    private func fetchAvgWaitingTimeForRestaurant(for stats: Statistics) {
        statsStorage.fetchTotalWaitingTimeForRestaurant(for: restaurant, stats: stats) { seconds in
            stats.totalWaitingTimeRestaurantPOV = seconds
            self.statsDelegate?.didCompleteFetchingData()
            if stats == self.currentStats {
                self.statsDetailsDelegate?.didCompleteFetchingData()
            }
        }
    }

    private func fetchQueueCancellationRate(for stats: Statistics) {
        statsStorage.fetchQueueCancellationRate(for: restaurant,
                                           stats: stats) { queueCount, withdrawCount in
            stats.totalNumOfQueueRecords = queueCount
            stats.totalQueueCancelled = withdrawCount
            self.statsDelegate?.didCompleteFetchingData()
            if stats == self.currentStats {
                self.statsDetailsDelegate?.didCompleteFetchingData()
            }
        }
    }

    private func fetchBookingCancellationRate(for stats: Statistics) {
        statsStorage.fetchBookingCancellationRate(for: restaurant,
                                             stats: stats) { bookCount, withdrawcount in
            stats.totalNumOfBookRecords = bookCount
            stats.totalBookingCancelled = withdrawcount
            self.statsDelegate?.didCompleteFetchingData()
            if stats == self.currentStats {
                self.statsDetailsDelegate?.didCompleteFetchingData()
            }
        }
    }
}

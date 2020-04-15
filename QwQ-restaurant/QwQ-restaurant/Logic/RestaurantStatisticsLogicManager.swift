import Foundation

class RestaurantStatisticsLogicManager: RestaurantStatisticsLogic {

    // Storage
    private let storage: RestaurantStatsStorage

    // View Controller
    weak var statsDelegate: StatsDelegate?
    weak var statsDetailsDelegate: StatsDetailsDelegate?

    // Models
    private let restaurantActivity: RestaurantActivity
    var restaurant: Restaurant {
        restaurantActivity.restaurant
    }

    enum StatsType {
        case daily
        case weekly
        case monthly
    }

    var currentStats: Statistics?

    var dailyStatsCollection = Collection<Statistics>()
    var dailyDetails: [Statistics] {
        dailyStatsCollection.statistics
    }

    var weeklyStatsCollection = Collection<Statistics>()
    var weeklyDetails: [Statistics] {
        weeklyStatsCollection.statistics
    }

    var monthlyStatsCollection = Collection<Statistics>()
    var monthlyDetails: [Statistics] {
        monthlyStatsCollection.statistics
    }

    var dailySummary: Statistics?
    var weeklySummary: Statistics?
    var monthlySummary: Statistics?

    convenience init() {
        self.init(storage: FIRStatsStorage.shared,
                  restaurantActivity: RestaurantActivity.shared())
    }

    init(storage: RestaurantStatsStorage, restaurantActivity: RestaurantActivity) {
        self.storage = storage
        self.restaurantActivity = restaurantActivity
    }

    func fetchDailyDetails() {
        let today = Date()
        for i  in 0..<10 {
            let fromDate = Calendar.current.date(byAdding: .day, value: -i, to: today)!
            let toDate = Calendar.current.date(byAdding: .day, value: -i, to: today)!
            let stats = loadStats(from: fromDate, to: toDate)
            dailyStatsCollection.addOrUpdate(stats)
        }
    }

    func fetchWeeklyDetails() {
        let tenWeeksAgo = Calendar.current.date(byAdding: .weekOfMonth, value: -9, to: Date())!
        for i  in (0..<10).reversed() {
            let fromDate = Calendar.current.date(byAdding: .weekOfMonth, value: i, to: tenWeeksAgo)!
            let temp = Calendar.current.date(byAdding: .weekOfMonth, value: i + 1, to: tenWeeksAgo)!
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
        for i  in 0..<12 {
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

    func fetchTotalNumCustomers(for stats: Statistics) {
        storage.fetchTotalNumCustomers(for: restaurant, from: stats.fromDate, to: stats.toDate) { count in
            stats.totalNumOfCustomers += count
            self.statsDelegate?.didCompleteFetchingData()
            if stats == self.currentStats {
                self.statsDetailsDelegate?.didCompleteFetchingData()
            }
        }
    }

    func fetchAvgWaitingTimeForCustomer(for stats: Statistics) {
        storage.fetchTotalWaitingTimeForCustomer(for: restaurant, from: stats.fromDate, to: stats.toDate) { seconds in
            stats.totalWaitingTimeCustomerPOV = seconds
            self.statsDelegate?.didCompleteFetchingData()
            if stats == self.currentStats {
                self.statsDetailsDelegate?.didCompleteFetchingData()
            }
        }
    }

    func fetchAvgWaitingTimeForRestaurant(for stats: Statistics) {
        storage.fetchTotalWaitingTimeForRestaurant(for: restaurant, from: stats.fromDate, to: stats.toDate) { seconds in
            stats.totalWaitingTimeRestaurantPOV = seconds
            self.statsDelegate?.didCompleteFetchingData()
            if stats == self.currentStats {
                self.statsDetailsDelegate?.didCompleteFetchingData()
            }
        }
    }

    func fetchQueueCancellationRate(for stats: Statistics) {
        storage.fetchQueueCancellationRate(for: restaurant,
                                           from: stats.fromDate, to: stats.toDate) { queueCount, withdrawCount in
            stats.totalNumOfQueueRecords = queueCount
            stats.totalQueueCancelled = withdrawCount
            self.statsDelegate?.didCompleteFetchingData()
            if stats == self.currentStats {
                self.statsDetailsDelegate?.didCompleteFetchingData()
            }
        }
    }

    func fetchBookingCancellationRate(for stats: Statistics) {
        storage.fetchBookingCancellationRate(for: restaurant,
                                             from: stats.fromDate, to: stats.toDate) { bookCount, withdrawcount in
            stats.totalNumOfBookRecords = bookCount
            stats.totalBookingCancelled = withdrawcount
            self.statsDelegate?.didCompleteFetchingData()
            if stats == self.currentStats {
                self.statsDetailsDelegate?.didCompleteFetchingData()
            }
        }
    }
}

import Foundation

/// Represents the protocol a logic handler of restaurant statistics should conform to.
protocol RestaurantStatisticsLogic {
    
    // MARK: View controllers
    /// Presentation delegate of statistics summary.
    var statsDelegate: StatsDelegate? { get set }
    /// Presentation delegate of detailed statistics.
    var statsDetailsDelegate: StatsDetailsDelegate? { get set }

    // MARK: Models
    var currentStats: Statistics? { get set }
    var dailyDetails: [Statistics] { get }
    var weeklyDetails: [Statistics] { get }
    var monthlyDetails: [Statistics] { get }
    var dailySummary: Statistics? { get }
    var weeklySummary: Statistics? { get }
    var monthlySummary: Statistics? { get }

    /// Fetches daily statistics.
    func fetchDailyDetails()
    /// Fetches weekly statistics.
    func fetchWeeklyDetails()
    /// Fetches monthly statistics.
    func fetchMonthlyDetails()
    /// Fetches summary statistics.
    func fetchSummary(type: StatsType)
    /// Loads and returns statistics collected from `date1` to `date2`.
    func loadStats(from date1: Date, to date2: Date) -> Statistics
}

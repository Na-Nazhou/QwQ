import Foundation

protocol RestaurantStatisticsLogic {

    // View Controllers
    var statsDelegate: StatsDelegate? { get set }
    var statsDetailsDelegate: StatsDetailsDelegate? { get set }

    // Models
    var currentStats: Statistics? { get set }
    var dailyDetails: [Statistics] { get }
    var weeklyDetails: [Statistics] { get }
    var monthlyDetails: [Statistics] { get }
    var dailySummary: Statistics? { get }
    var weeklySummary: Statistics? { get }
    var monthlySummary: Statistics? { get }

    func fetchSummary(type: StatsType)
    
    func fetchDailyDetails()
    func fetchWeeklyDetails()
    func fetchMonthlyDetails()

    func loadStats(from date1: Date, to date2: Date) -> Statistics
}

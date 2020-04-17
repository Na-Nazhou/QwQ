import Foundation

protocol RestaurantStatisticsLogic {

    // View Controllers
    var statsDelegate: StatsDelegate? { get set }
    var statsDetailsDelegate: StatsDetailsDelegate? { get set }

    func fetchSummary(type: StatsType)
    
    func fetchDailyDetails()
    func fetchWeeklyDetails()
    func fetchMonthlyDetails()

    func loadStats(from date1: Date, to date2: Date) -> Statistics
}

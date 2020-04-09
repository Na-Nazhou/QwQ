import Foundation

protocol RestaurantStatisticsLogic {

    // View Controllers
    var statsDelegate: StatsPresentationDelegate? { get set }

    func fetchDailyDetails()
    func fetchWeeklyDetails()
    func fetchMonthlyDetails()
}

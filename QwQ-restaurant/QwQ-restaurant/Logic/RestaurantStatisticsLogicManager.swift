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

    private(set) var currentStats: Statistics

    convenience init() {
        self.init(storage: FIRStatsStorage.shared,
                  restaurantActivity: RestaurantActivity.shared())
    }

    init(storage: RestaurantStatsStorage, restaurantActivity: RestaurantActivity) {
        self.storage = storage
        self.restaurantActivity = restaurantActivity

        currentStats = Statistics(fromDate: Date(), toDate: Date())
    }

    func loadAllStats(from date: Date, to date2: Date) {
        currentStats = Statistics(fromDate: date, toDate: date2)

        fetchTotalNumCustomers(from: date, to: date2)
    }

    func fetchTotalNumCustomers(from date: Date, to date2: Date) {
        storage.fetchTotalNumCustomers(for: restaurant, from: date, to: date2) { count in
            self.currentStats.totalNumCustomers += count
        }
    }

    func fetchAvgWaitingTimeForCustomer(from date: Date, to date2: Date) {
        storage.fetchTotalWaitingTimeForCustomer(for: restaurant, from: date, to: date2) { seconds in
            self.currentStats.totalWaitingTimeCustomerPOV += seconds
        }
    }

    func fetchAvgWaitingTimeForRestaurant(from date: Date, to date2: Date) {
        storage.fetchTotalWaitingTimeForRestaurant(for: restaurant, from: date, to: date2) { seconds in
            self.currentStats.totalWaitingTimeRestaurantPOV += seconds
        }
    }

    func fetchQueueCancellationRate(from date: Date, to date2: Date) {
        storage.fetchQueueCancellationRate(for: restaurant, from: date, to: date2) { count in
            self.currentStats.totalQueueCancelled += count
        }
    }

    func fetchBookingCancellationRate(from date: Date, to date2: Date) {
        storage.fetchBookingCancellationRate(for: restaurant, from: date, to: date2) { count in
            self.currentStats.totalBookingCancelled += count
        }
    }
    
}

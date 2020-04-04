import Foundation
class RestaurantStatisticsLogicManager: RestaurantStatisticsLogic {
    private let storage: RestaurantStatsStorage
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
        storage.totalNumCustomers(for: restaurant, from: date, to: date2) { count in
            self.currentStats.numberOfCustomers += count
        }
    }

    func avgWaitingTimeForCustomer(from date: Date, to date2: Date) {
        storage.avgWaitingTimeForCustomer(for: restaurant, from: date, to: date2) { stat in
            //avg waiting time delegate bla
        }
    }

    func queueCancellationRate(from date: Date, to date2: Date) {
        storage.queueCancellationRate(for: restaurant, from: date, to: date2) { stat in
            //queue cancellation numbers
        }
    }

    func bookingCancellationRate(from date: Date, to date2: Date) {
        storage.bookingCancellationRate(for: restaurant, from: date, to: date2) { stat in
            //booking cancellation numbers
        }
    }
    
}

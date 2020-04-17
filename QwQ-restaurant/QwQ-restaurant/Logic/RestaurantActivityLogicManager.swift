import Foundation

class RestaurantActivityLogicManager: RestaurantActivityLogic {

    // Models
    private let restaurantActivity: RestaurantActivity

    var currentRecords: [Record] {
        restaurantActivity.currentRecords
    }

    var waitingRecords: [Record] {
        restaurantActivity.waitingRecords
    }

    var historyRecords: [Record] {
        restaurantActivity.historyRecords
    }

    init() {
        self.restaurantActivity = RestaurantActivity.shared()
    }
}

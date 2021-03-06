import Foundation
import os

/// A logic manager that handles restaurants.
class RestaurantLogicManager: RestaurantLogic {

    // Storage
    typealias RestaurantStorage = FIRRestaurantStorage
    private let queueStorage: RestaurantQueueStorage

    // View Controller
    weak var activitiesDelegate: ActivitiesDelegate?

    // Timers
    private var openQueueTimer: Timer?
    private var closeQueueTimer: Timer?

    // Models
    private let restaurantActivity: RestaurantActivity
    private var restaurant: Restaurant {
        restaurantActivity.restaurant
    }

    var isQueueOpen: Bool {
        restaurant.isQueueOpen
    }

    convenience init() {
        self.init(restaurantActivity: RestaurantActivity.shared())
    }

    /// Constructs a restaurant logic manager and starts the timer to automatically close/open the queue.
    init(restaurantActivity: RestaurantActivity) {
        self.restaurantActivity = restaurantActivity
        self.queueStorage = FIRQueueStorage.shared

        RestaurantStorage.delegate = self

        scheduleQueueStatusTimer()
    }

    deinit {
        openQueueTimer?.invalidate()
        closeQueueTimer?.invalidate()
    }

    /// Schedules the timers to automatically open/close the queues.
    private func scheduleQueueStatusTimer() {
        guard restaurant.isAutoOpenCloseEnabled else {
            return
        }

        openQueueTimer?.invalidate()
        openQueueTimer = Timer(fireAt: restaurant.nextAutoOpenTime,
                               interval: Date.day,
                               target: self,
                               selector: #selector(handleOpenQueueTimer),
                               userInfo: nil,
                               repeats: true)
        RunLoop.main.add(openQueueTimer!, forMode: .common)

        closeQueueTimer?.invalidate()
        closeQueueTimer = Timer(fireAt: restaurant.nextAutoCloseTime,
                                interval: Date.day,
                                target: self,
                                selector: #selector(handleCloseQueueTimer),
                                userInfo: nil,
                                repeats: true)
        RunLoop.main.add(closeQueueTimer!, forMode: .common)
    }

    @objc private func handleOpenQueueTimer() {
        os_log("Fire open queue timer",
               log: Log.automaticQueueOpenClose, type: .info)
        openQueue()
    }

    @objc private func handleCloseQueueTimer() {
        os_log("Fire close queue timer",
               log: Log.automaticQueueOpenClose, type: .info)
        closeQueue()
    }
    
    /// Opens queue and registers the opening time of the restaurant as the current time.
    func openQueue() {
        guard !restaurant.isQueueOpen else {
            return
        }

        let time = Date()
        var new = restaurant
        new.openQueue(at: time)
        updateRestaurant(new: new)
    }
    
    /// Closes queue and registers the closing time of the restaurant as the current time.
    func closeQueue() {
        guard restaurant.isQueueOpen else {
            return
        }

        let time = Date()
        var new = restaurant
        new.closeQueue(at: time)
        updateRestaurant(new: new)
    }

    private func updateRestaurant(new: Restaurant) {
        RestaurantStorage.updateRestaurantInfo(restaurant: new,
                                               completion: {},
                                               errorHandler: { _ in })
    }
}

extension RestaurantLogicManager {
    // MARK: Syncing
    func didUpdateRestaurant(restaurant: Restaurant) {
        restaurantActivity.updateRestaurant(restaurant)
        scheduleQueueStatusTimer()
        activitiesDelegate?.didUpdateRestaurant()
    }
}

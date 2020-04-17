//
//  RestaurantLogicManager.swift
//  QwQ-restaurant
//
//  Created by Nazhou Na on 16/4/20.
//

import Foundation

class RestaurantLogicManager: RestaurantLogic {

    // Storage
    typealias RestaurantStorage = FIRRestaurantStorage
    let queueStorage: RestaurantQueueStorage = FIRQueueStorage.shared

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

    init(restaurantActivity: RestaurantActivity) {
        self.restaurantActivity = restaurantActivity

        RestaurantStorage.delegate = self

        scheduleQueueStatusTimer()
    }

    deinit {
        openQueueTimer?.invalidate()
        closeQueueTimer?.invalidate()
    }

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

    @objc func handleOpenQueueTimer() {
        print("fire open queue timer")
        openQueue()
    }

    @objc func handleCloseQueueTimer() {
        print("fire close queue timer")
        closeQueue()
    }

    func openQueue() {
        guard !restaurant.isQueueOpen else {
            return
        }

        let time = Date()
        var new = restaurant
        new.queueOpenTime = time
        updateRestaurant(new: new)
    }

    func closeQueue() {
        guard restaurant.isQueueOpen else {
            return
        }

        let time = Date()
        var new = restaurant
        new.queueCloseTime = time
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

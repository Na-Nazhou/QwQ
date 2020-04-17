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

    // View Controller
    weak var activitiesDelegate: ActivitiesDelegate?

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
    }

    func openQueue() {
        let time = Date()
        var new = restaurant
        new.queueOpenTime = time

        RestaurantStorage.updateRestaurantInfo(restaurant: new,
                                               completion: {},
                                               errorHandler: { _ in })
    }

    func closeQueue() {
        let time = Date()
        var new = restaurant
        new.queueCloseTime = time

        RestaurantStorage.updateRestaurantInfo(restaurant: new,
                                               completion: {},
                                               errorHandler: { _ in })
    }

    func didUpdateRestaurant(restaurant: Restaurant) {
        restaurantActivity.updateRestaurant(restaurant)
        activitiesDelegate?.didUpdateRestaurant()
    }
}

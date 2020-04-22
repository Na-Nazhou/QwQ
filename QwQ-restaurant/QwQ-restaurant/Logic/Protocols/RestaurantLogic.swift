//
//  RestaurantLogic.swift
//  QwQ-restaurant
//
//  Created by Nazhou Na on 17/4/20.
//

protocol RestaurantLogic: RestaurantStorageSyncDelegate {

    // View Controllers
    var activitiesDelegate: ActivitiesDelegate? { get set }

    // Models
    var isQueueOpen: Bool { get }

    /// Opens queue anfethadd registers the opening time of the restaurant as the current time.
    func openQueue()
    /// Closes queue and registers the closing time of the restaurant as the current time.
    func closeQueue()
}

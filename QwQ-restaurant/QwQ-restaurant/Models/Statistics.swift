//
//  Statistics.swift
//  QwQ-restaurant
//
//  Created by Tan Su Yee on 25/3/20.
//

import Foundation

struct Statistics {
    let fromDate: Date
    let toDate: Date!

    // MARK: Raw stats
    var totalNumCustomers: Int = 0
    var totalWaitingTimeCustomerPOV: Int = 0
    var totalWaitingTimeRestaurantPOV: Int = 0
    var totalQueueCancelled: Int = 0
    var totalBookingCancelled: Int = 0
    
    // MARK: Computed stats
    var queueCancellationRate: Int {
        totalQueueCancelled
    }
    var bookingCancellationRate: Int {
        totalBookingCancelled
    }
    var numberOfCustomers: Int {
        totalNumCustomers
    }
    var avgWaitingTimeRestaurant: Int {
        totalNumCustomers == 0
            ? 0
            : totalWaitingTimeRestaurantPOV / totalNumCustomers
    }
    var avgWaitingTimeCustomer: Int {
        totalNumCustomers == 0
            ? 0
            : totalWaitingTimeCustomerPOV / totalNumCustomers
    }
    
    init(fromDate: Date, toDate: Date) {
        self.fromDate = fromDate
        self.toDate = toDate
    }
}

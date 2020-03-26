//
//  Statistics.swift
//  QwQ-restaurant
//
//  Created by Tan Su Yee on 25/3/20.
//

import Foundation

struct Statistics {
    let queueCancellationRate: Int!
    let bookingCancellationRate: Int!
    let numberOfCustomers: Int!
    let avgWaitingTimeRestaurant: Int!
    let avgWaitingTimeCustomer: Int!
    let date: Date!
    
    init(queueCancellationRate: Int, bookingCancellationRate: Int,
         numberOfCustomers: Int, avgWaitingTimeRestaurant: Int,
         avgWaitingTimeCustomer: Int, date: Date) {
        self.queueCancellationRate = queueCancellationRate
        self.bookingCancellationRate = bookingCancellationRate
        self.numberOfCustomers = numberOfCustomers
        self.avgWaitingTimeRestaurant = avgWaitingTimeRestaurant
        self.avgWaitingTimeCustomer = avgWaitingTimeCustomer
        self.date = date
    }
}

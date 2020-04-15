//
//  Statistics.swift
//  QwQ-restaurant
//
//  Created by Tan Su Yee on 25/3/20.
//

import Foundation

class Statistics {
    let fromDate: Date
    let toDate: Date

    var formattedDateRange: String {
        if Date.isSameDay(date1: fromDate, date2: toDate) {
            return "\(fromDate.getFomattedDate())"
        } else {
            return "\(fromDate.getFomattedDate()) - \(toDate.getFomattedDate())"
        }
    }

    // MARK: Raw stats
    var totalNumOfCustomers: Int = 0
    var totalWaitingTimeCustomerPOV: Int = 0
    var totalWaitingTimeRestaurantPOV: Int = 0

    var totalQueueCancelled: Int = 0
    var totalNumOfQueueRecords: Int = 0

    var totalBookingCancelled: Int = 0
    var totalNumOfBookRecords: Int = 0

    var totalNumOfRecords: Int {
        totalNumOfQueueRecords + totalNumOfBookRecords
    }
    
    // MARK: Computed stats
    var numberOfCustomers: Int {
        totalNumOfCustomers
    }

    var avgWaitingTimeRestaurant: Int {
        totalNumOfCustomers == 0
            ? 0
            : totalWaitingTimeRestaurantPOV / totalNumOfRecords / 60
    }

    var avgWaitingTimeCustomer: Int {
        totalNumOfCustomers == 0
            ? 0
            : totalWaitingTimeCustomerPOV / totalNumOfRecords / 60
    }

    var queueCancellationRate: Int {
        totalNumOfQueueRecords == 0
            ? 0
            : 100 * totalQueueCancelled / totalNumOfQueueRecords
    }

    var bookingCancellationRate: Int {
        totalNumOfBookRecords == 0
            ? 0
            : 100 * totalBookingCancelled / totalNumOfBookRecords
    }
    
    init(fromDate: Date, toDate: Date) {
        self.fromDate = fromDate
        self.toDate = toDate
    }
}

extension Statistics: Hashable {
    static func == (lhs: Statistics, rhs: Statistics) -> Bool {
        lhs.fromDate == rhs.fromDate && lhs.toDate == rhs.toDate
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(fromDate)
        hasher.combine(toDate)
    }
}

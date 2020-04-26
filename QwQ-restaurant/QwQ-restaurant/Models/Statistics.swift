import Foundation

/// A statistics model.
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

    init(fromDate: Date, toDate: Date) {
        self.fromDate = Date.getStartOfDay(of: fromDate)
        self.toDate = Date.getEndOfDay(of: toDate)
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

    var formattedQueueCancellationRate: String {
        "\(totalQueueCancelled)/\(totalNumOfQueueRecords) (\(queueCancellationRate)%)"
    }

    var bookingCancellationRate: Int {
        totalNumOfBookRecords == 0
            ? 0
            : 100 * totalBookingCancelled / totalNumOfBookRecords
    }

    var formattedBookingCancellationRate: String {
        "\(totalBookingCancelled)/\(totalNumOfBookRecords) (\(bookingCancellationRate)%)"
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

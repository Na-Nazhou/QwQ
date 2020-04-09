//
//  StatisticsCell.swift
//  QwQ-restaurant
//
//  Created by Tan Su Yee on 25/3/20.
//

import UIKit

class StatisticsCell: UITableViewCell {

    // MARK: View properties
    @IBOutlet private var dateLabel: UILabel!
    @IBOutlet private var avgWaitingTimeRestaurantLabel: UILabel!
    @IBOutlet private var avgWaitingTimeCustomerLabel: UILabel!
    
    func setUpViews(details: Statistics) {
        let dateFormat = "\(details.fromDate.getFomattedDate()) - \(details.toDate.getFomattedDate())"
        dateLabel.text = dateFormat
        avgWaitingTimeRestaurantLabel.text = "\(details.avgWaitingTimeRestaurant) mins"
        avgWaitingTimeCustomerLabel.text = "\(details.avgWaitingTimeCustomer) mins"
    }
}

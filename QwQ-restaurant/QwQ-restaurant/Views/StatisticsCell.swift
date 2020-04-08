//
//  StatisticsCell.swift
//  QwQ-restaurant
//
//  Created by Tan Su Yee on 25/3/20.
//

import UIKit

class StatisticsCell: UITableViewCell {
    @IBOutlet private var dateLabel: UILabel!
    @IBOutlet private var avgWaitingTimeRestaurantLabel: UILabel!
    @IBOutlet private var avgWaitingTimeCustomerLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setUpViews(statisticsDetail: Statistics) {
        // TODO: add fromDate
        let dateFormat = Date.getFormattedDate(date: statisticsDetail.toDate, format: Constants.statisticsDateFormat)
        dateLabel.text = dateFormat
        avgWaitingTimeRestaurantLabel.text = "\(statisticsDetail.avgWaitingTimeRestaurant) mins"
        avgWaitingTimeCustomerLabel.text = "\(statisticsDetail.avgWaitingTimeCustomer) mins"
    }
}

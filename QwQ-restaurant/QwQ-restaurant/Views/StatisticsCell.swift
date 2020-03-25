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
        let dateFormat = Date.getFormattedDate(date: statisticsDetail.date, format: "dd/MM/yyyy")
        dateLabel.text = dateFormat
        avgWaitingTimeRestaurantLabel.text = "\(statisticsDetail.avgWaitingTimeRestaurant ?? 0) mins"
        avgWaitingTimeCustomerLabel.text = "\(statisticsDetail.avgWaitingTimeCustomer ?? 0) mins"
    }
}

//
//  StatisticsCell.swift
//  QwQ-restaurant
//
//  Created by Tan Su Yee on 25/3/20.
//

import UIKit

class StatisticsCell: UITableViewCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var avgRestaurantWaitingTimeLabel: UILabel!
    @IBOutlet weak var avgCustomerWaitingTimeLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setUpViews(statisticsDetail: String) {
        dateLabel.text = statisticsDetail
        avgRestaurantWaitingTimeLabel.text = "\(statisticsDetail) mins"
        avgCustomerWaitingTimeLabel.text = "\(statisticsDetail) mins"
        print("setupviews \(avgRestaurantWaitingTimeLabel)")
    }
}

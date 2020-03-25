//
//  StatisticsDetailsViewController.swift
//  QwQ-restaurant
//
//  Created by Tan Su Yee on 25/3/20.
//

import UIKit

class StatisticsDetailsViewController: UIViewController {
    @IBOutlet private var queueCancellationRateLabel: UILabel!
    @IBOutlet private var bookingCancellationRateLabel: UILabel!
    @IBOutlet private var numberOfCustomersLabel: UILabel!
    @IBOutlet private var avgWaitingTimeRestaurantLabel: UILabel!
    @IBOutlet private var avgWaitingTimeCustomerLabel: UILabel!
    @IBOutlet private var dateLabel: UILabel!
    
    @IBAction func handleBack(_ sender: Any) {
        handleBack()
    }
    
    var statisticsDetails: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViews()
    }
    
    private func setUpViews() {
        queueCancellationRateLabel.text = "\(statisticsDetails)%"
        bookingCancellationRateLabel.text = "\(statisticsDetails)%"
        numberOfCustomersLabel.text = "\(statisticsDetails)"
        avgWaitingTimeRestaurantLabel.text = "\(statisticsDetails) mins"
        avgWaitingTimeCustomerLabel.text = "\(statisticsDetails) mins"
        dateLabel.text = "\(statisticsDetails)"
    }
}

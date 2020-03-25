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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}


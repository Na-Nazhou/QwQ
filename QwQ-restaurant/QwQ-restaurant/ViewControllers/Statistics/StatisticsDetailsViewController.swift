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
    
    @IBAction private func handleBack(_ sender: Any) {
        handleBack()
    }
    
    var statisticsDetails: Statistics?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViews()
    }
    
    private func setUpViews() {
        guard let details = statisticsDetails else {
            return
        }
        
        queueCancellationRateLabel.text = "\(details.queueCancellationRate)%"
        bookingCancellationRateLabel.text = "\(details.bookingCancellationRate)%"
        numberOfCustomersLabel.text = "\(details.numberOfCustomers)"
        avgWaitingTimeRestaurantLabel.text = "\(details.avgWaitingTimeRestaurant) mins"
        avgWaitingTimeCustomerLabel.text = "\(details.avgWaitingTimeCustomer) mins"
        dateLabel.text = "\(details.toDate ?? Date())"
        //TODO: add fromDate
    }
}

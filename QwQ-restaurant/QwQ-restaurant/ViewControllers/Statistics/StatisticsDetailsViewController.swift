//
//  StatisticsDetailsViewController.swift
//  QwQ-restaurant
//
//  Created by Tan Su Yee on 25/3/20.
//

import UIKit

class StatisticsDetailsViewController: UIViewController {

    // MARK: View properties
    @IBOutlet private var queueCancellationRateLabel: UILabel!
    @IBOutlet private var bookingCancellationRateLabel: UILabel!
    @IBOutlet private var numberOfCustomersLabel: UILabel!
    @IBOutlet private var avgWaitingTimeRestaurantLabel: UILabel!
    @IBOutlet private var avgWaitingTimeCustomerLabel: UILabel!
    @IBOutlet private var dateLabel: UILabel!

    var spinner: UIView?

    // MARK: Logic properties
    var statsLogic: RestaurantStatisticsLogic!

    // MARK: Model properties
    private var statisticsDetails: Statistics? {
        statsLogic.currentStats
    }
    
    @IBAction private func handleBack(_ sender: Any) {
        handleBack()
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()

        statsLogic.statsDetailsDelegate = self

        setUpViews()
    }
    
    private func setUpViews() {
        guard let details = statisticsDetails else {
            return
        }
        
        queueCancellationRateLabel.text = details.formattedQueueCancellationRate
        bookingCancellationRateLabel.text = details.formattedBookingCancellationRate
        numberOfCustomersLabel.text = "\(details.numberOfCustomers)"
        avgWaitingTimeRestaurantLabel.text = "\(details.avgWaitingTimeRestaurant) mins"
        avgWaitingTimeCustomerLabel.text = "\(details.avgWaitingTimeCustomer) mins"
        dateLabel.text = details.formattedDateRange
    }
}

extension StatisticsDetailsViewController: StatsDetailsDelegate {

    func didCompleteFetchingData() {
        setUpViews()
    }

}

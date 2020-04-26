//
//  StatisticsViewController.swift
//  QwQ-restaurant
//
//  Created by Tan Su Yee on 25/3/20.
//

/**
 `StatisticsViewController` manages statistics of restaurant.
 
 It must conform to `StatsDelegate` to handle statistics after loading.
 */

import UIKit
import os

class StatisticsViewController: UIViewController {
    
    // MARK: View properties
    @IBOutlet private var avgWaitingTimeRestaurantLabel: UILabel!
    @IBOutlet private var avgWaitingTimeCustomerLabel: UILabel!
    @IBOutlet private var statisticsTableView: UITableView!
    @IBOutlet private var statisticsControl: SegmentedControl!
    @IBOutlet private var fromDatePicker: UIDatePicker!
    @IBOutlet private var toDatePicker: UIDatePicker!
    
    private var spinner: UIView?
    
    // MARK: Segmented control
    private enum SelectedControl: Int {
        case daily
        case weekly
        case monthly
    }
    private var selectedControl: SelectedControl = .daily
    
    // MARK: Logic properties
    private var statsLogic: RestaurantStatisticsLogic = RestaurantStatisticsLogicManager()
    
    // MARK: Model properties
    private var statistics: [Statistics] {
        switch selectedControl {
        case .daily:
            return statsLogic.dailyDetails
        case .weekly:
            return statsLogic.weeklyDetails
        case .monthly:
            return statsLogic.monthlyDetails
        }
    }
    
    private var summary: Statistics? {
        switch selectedControl {
        case .daily:
            return statsLogic.dailySummary
        case .weekly:
            return statsLogic.weeklySummary
        case .monthly:
            return statsLogic.monthlySummary
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        statisticsTableView.delegate = self
        statisticsTableView.dataSource = self
        
        statsLogic.statsDelegate = self
        
        setUpSegmentedControl()
        setUpDatePickers()
        setUpWaitingTimeLabels()
    }
    
    /// Filter restaurant statistics by time period
    @IBAction func handleFilterByDate(_ sender: Any) {
        let fromDate = fromDatePicker.date
        let toDate = toDatePicker.date
        
        if fromDate > toDate {
            showMessage(title: Constants.errorTitle,
                        message: Constants.startAfterEndMessage,
                        buttonText: Constants.okayTitle)
        } else {
            let statisticsDetails = statsLogic.loadStats(from: fromDate, to: toDate)
            performSegue(withIdentifier: Constants.statisticsSelectedSegue, sender: statisticsDetails)
        }
    }
    
    @IBAction private func onTapSegButton(_ sender: SegmentedControl) {
        selectedControl = SelectedControl(rawValue: sender.selectedIndex)!
        fetchData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let statisticsDetailsViewController = segue.destination as? StatisticsDetailsViewController,
            let statisticsDetails = sender as? Statistics {
            
            statsLogic.currentStats = statisticsDetails
            statisticsDetailsViewController.statsLogic = statsLogic
        } else {
            os_log("Segue not found.", log: Log.segueError, type: .error)
        }
    }
    
    /// Get restaurant statistics summary by day, week and month
    private func fetchData() {
        switch selectedControl {
        case .daily:
            statsLogic.fetchDailyDetails()
            statsLogic.fetchSummary(type: .daily)
        case .weekly:
            statsLogic.fetchWeeklyDetails()
            statsLogic.fetchSummary(type: .weekly)
        case .monthly:
            statsLogic.fetchMonthlyDetails()
            statsLogic.fetchSummary(type: .monthly)
        }
        setUpWaitingTimeLabels()
        spinner = showSpinner(onView: view)
    }
    
    private func setUpSegmentedControl() {
        statisticsControl.items = Constants.segmentedControlStatisticsTitles
        statisticsControl.addTarget(self, action: #selector(onTapSegButton), for: .valueChanged)
        fetchData()
    }
    
    private func setUpDatePickers() {
        fromDatePicker.maximumDate = Date()
        toDatePicker.maximumDate = Date()
        
        fromDatePicker.date = Date().getDateOf(daysBeforeDate: 7)
        toDatePicker.date = Date()
    }
    
    private func setUpWaitingTimeLabels() {
        guard let avgWaitingTimeRestaurant = summary?.avgWaitingTimeRestaurant,
            let avgWaitingTimeCustomer = summary?.avgWaitingTimeCustomer else {
                return
        }
        avgWaitingTimeRestaurantLabel.text = "\(avgWaitingTimeRestaurant) mins"
        avgWaitingTimeCustomerLabel.text = "\(avgWaitingTimeCustomer) mins"
    }
}

extension StatisticsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        statistics.count
    }
    
    /// Set up statistics cell with statistics record details
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = statisticsTableView
            .dequeueReusableCell(withIdentifier: Constants.statisticsReuseIdentifier,
                                 for: indexPath)
        
        guard let statisticsCell = cell as? StatisticsCell else {
            return cell
        }
        
        let statisticsDetails = statistics[indexPath.row]
        statisticsCell.setUpViews(details: statisticsDetails)
        
        return statisticsCell
    }
    
    /// Segue to statistics detail page to show specific details of the statistics record
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let statisticsDetails = statistics[indexPath.row]
        performSegue(withIdentifier: Constants.statisticsSelectedSegue, sender: statisticsDetails)
    }
}

extension StatisticsViewController: StatsDelegate {
    func didCompleteFetchingData() {
        removeSpinner(spinner)
        
        setUpWaitingTimeLabels()
        statisticsTableView.reloadData()
    }
}

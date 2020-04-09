//
//  StatisticsViewController.swift
//  QwQ-restaurant
//
//  Created by Tan Su Yee on 25/3/20.
//

import UIKit

class StatisticsViewController: UIViewController {

    // MARK: View properties
    @IBOutlet private var avgWaitingTimeRestaurantLabel: UILabel!
    @IBOutlet private var avgWaitingTimeCustomerLabel: UILabel!
    @IBOutlet private var statisticsTableView: UITableView!
    @IBOutlet private var statisticsControl: SegmentedControl!

    var spinner: UIView?

    enum SelectedControl: Int {
        case daily
        case weekly
        case monthly
    }
    var selectedControl: SelectedControl = .daily

    // MARK: Logic properties
    let statsManager = RestaurantStatisticsLogicManager()

    // MARK: Model properties
    var statistics: [Statistics] {
        switch selectedControl {
        case .daily:
            return statsManager.dailyDetails
        case .weekly:
            return statsManager.weeklyDetails
        case .monthly:
            return statsManager.monthlyDetails
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        statisticsTableView.delegate = self
        statisticsTableView.dataSource = self

        statsManager.statsDelegate = self

        setUpSegmentedControl()
    }

    private func setUpSegmentedControl() {
        statisticsControl.items = Constants.segmentedControlStatisticsTitles
        statisticsControl.addTarget(self, action: #selector(onTapSegButton), for: .valueChanged)
        fetchData()
    }

    @IBAction private func onTapSegButton(_ sender: SegmentedControl) {
        selectedControl = SelectedControl(rawValue: sender.selectedIndex)!
        fetchData()
    }

    private func fetchData() {
        switch selectedControl {
        case .daily:
            statsManager.fetchDailyDetails()
        case .weekly:
            statsManager.fetchWeeklyDetails()
        case .monthly:
            statsManager.fetchMonthlyDetails()
        }
        spinner = showSpinner(onView: view)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let statisticsDetailsViewController = segue.destination as? StatisticsDetailsViewController,
            let statisticsDetails = sender as? Statistics {
            statisticsDetailsViewController.statisticsDetails = statisticsDetails
        }
    }
}

extension StatisticsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        statistics.count
    }
    
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let statisticsDetails = statistics[indexPath.row]
        performSegue(withIdentifier: Constants.statisticsSelectedSegue, sender: statisticsDetails)
    }
}

extension StatisticsViewController: StatsPresentationDelegate {

    func didCompleteFetchingData() {
        removeSpinner(spinner)

        statisticsTableView.reloadData()
    }
    
}

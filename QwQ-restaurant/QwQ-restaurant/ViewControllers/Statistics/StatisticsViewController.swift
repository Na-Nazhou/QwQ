//
//  StatisticsViewController.swift
//  QwQ-restaurant
//
//  Created by Tan Su Yee on 25/3/20.
//

import UIKit

class StatisticsViewController: UIViewController {
    @IBOutlet private var avgWaitingTimeRestaurantLabel: UILabel!
    @IBOutlet private var avgWaitingTimeCustomerLabel: UILabel!
    @IBOutlet private var statisticsTableView: UITableView!
    @IBOutlet private var statisticsControl: SegmentedControl!
    
//    var statistics: [Statistics] = [Statistics(queueCancellationRate: 12, bookingCancellationRate: 1,
//                                               numberOfCustomers: 2, avgWaitingTimeRestaurant: 3,
//                                               avgWaitingTimeCustomer: 4, date: Date())]
    let statsManager = RestaurantStatisticsLogicManager()
    var statistics: [Statistics] {
        [statsManager.currentStats]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        statisticsControl.items = Constants.segmentedControlStatisticsTitles
        
        statisticsTableView.delegate = self
        statisticsTableView.dataSource = self

        statsManager.statsDelegate = self
        statsManager.loadAllStats(from: Date().getDateOf(daysBeforeDate: 7), to: Date())
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
        return statistics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = statisticsTableView
            .dequeueReusableCell(withIdentifier: Constants.statisticsReuseIdentifier,
                                 for: indexPath)
    
        guard let statisticsCell = cell as? StatisticsCell else {
            return cell
        }
        
        let statisticsDetails = statistics[indexPath.row]
        
        statisticsCell.setUpViews(statisticsDetail: statisticsDetails)
    
        return statisticsCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let statisticsDetails = statistics[indexPath.row]
        print("\n\tTRIGGERED PERFORM SEGUE IN VC \n")
        performSegue(withIdentifier: Constants.statisticsSelectedSegue, sender: statisticsDetails)
    }
}

extension StatisticsViewController: StatsPresentationDelegate {

    func statsDidUpdate() {
        statisticsTableView.reloadData()
    }
    
}

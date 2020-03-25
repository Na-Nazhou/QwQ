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
    
    var statistics: [String] = ["1"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        statisticsTableView.delegate = self
        statisticsTableView.dataSource = self
    }
}

extension StatisticsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("stats \(statistics.count)")
        return statistics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = statisticsTableView
            .dequeueReusableCell(withIdentifier: Constants.statisticsReuseIdentifier,
                                 for: indexPath)
        
        guard let statisticsCell = cell as? StatisticsCell else {
            return cell
        }
        
        let statisticsDetail = statistics[indexPath.row]
        
        statisticsCell.setUpViews(statisticsDetail: statisticsDetail)
        
        return statisticsCell
    }
}

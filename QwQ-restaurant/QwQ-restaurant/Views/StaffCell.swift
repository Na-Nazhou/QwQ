//
//  StatisticsCell.swift
//  QwQ-restaurant
//
//  Created by Tan Su Yee on 30/3/20.
//

import UIKit

class StaffCell: UITableViewCell {

    // MARK: View properties
    @IBOutlet private var emailLabel: UILabel!
    
    func setUpViews(staffEmail: String) {
        emailLabel.text = staffEmail
    }
}

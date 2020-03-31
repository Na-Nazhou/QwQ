//
//  StatisticsCell.swift
//  QwQ-restaurant
//
//  Created by Tan Su Yee on 30/3/20.
//

import UIKit

class StaffCell: UITableViewCell {
    @IBOutlet private var emailLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setUpViews(staffEmail: String) {
        emailLabel.text = staffEmail
    }
}

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
    @IBOutlet var roleLabel: UILabel!
    @IBOutlet var editPermissionsButton: UIButton!

    func setUpViews(staff: Staff) {
        emailLabel.text = staff.email
        roleLabel.text = staff.roleName
    }
}

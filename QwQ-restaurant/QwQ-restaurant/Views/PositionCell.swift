//
//  PositionCell.swift
//  QwQ-restaurant
//
//  Created by Daniel Wong on 23/4/20.
//

import UIKit

class PositionCell: UITableViewCell {

    @IBOutlet var roleLabel: UILabel!

    func setUpViews(position: Role) {
        self.roleLabel.text = position.roleName
    }

}

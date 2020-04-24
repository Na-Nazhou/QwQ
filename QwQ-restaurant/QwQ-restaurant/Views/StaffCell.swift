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
    @IBOutlet private var roleLabel: UILabel!
    @IBOutlet private var editPermissionsButton: UIButton!

    weak var delegate: StaffCellDelegate?

    var email: String {
        if let email = emailLabel.text {
            return email
        }
        return ""
    }

    func setUpViews(staffPosition: StaffPosition) {
        emailLabel.text = staffPosition.email
        roleLabel.text = staffPosition.roleName

        if staffPosition.roleName == Constants.ownerPermissionsKey {
            disableEditPermissionsButton()
        }
    }

    func updateRoleLabel(roleName: String) {
        roleLabel.text = roleName
    }

    @IBAction func editRole(_ sender: UIButton) {
        delegate?.editRoleButtonPressed(cell: self, button: sender)
    }

    private func disableEditPermissionsButton() {
        editPermissionsButton.isEnabled = false
        editPermissionsButton.isHidden = true
    }
}

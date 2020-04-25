//
//  RoleCell.swift
//  QwQ-restaurant
//
//  Created by Daniel Wong on 23/4/20.
//

import UIKit

class RoleCell: UITableViewCell {

    // MARK: View properties
    @IBOutlet private var roleNameLabel: UILabel!
    @IBOutlet private var permissionsTextView: UITextView!
    @IBOutlet private var editButton: UIButton!

    weak var delegate: RoleCellDelegate?
    var currentRole: Role?

    func setupViews(role: Role) {
        self.roleNameLabel.text = role.roleName
        self.permissionsTextView.text = convertPermissionsToString(permissions: role.permissions)
        self.currentRole = role

        if role.roleName == Constants.ownerPermissionsKey {
            disableEditButton()
        }
    }

    @IBAction func handleEdit(_ sender: UIButton) {
        delegate?.editPermissionsButtonPressed(cell: self, button: sender)
    }

    private func disableEditButton() {
        editButton.isEnabled = false
        editButton.isHidden = true
    }

    private func convertPermissionsToString(permissions: [Permission]) -> String {
        var resultString = ""
        for permission in permissions {
            resultString += permission.localizedDescription
            resultString += ", "
        }
        return String(resultString.dropLast().dropLast())
    }
}

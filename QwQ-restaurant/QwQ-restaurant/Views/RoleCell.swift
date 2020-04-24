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
    @IBOutlet var permissionsTextView: UITextView!
    @IBOutlet var editButton: UIButton!

    func setupViews(role: Role) {
        self.roleNameLabel.text = role.roleName
        self.permissionsTextView.text = convertPermissionsToString(permissions: role.permissions)

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

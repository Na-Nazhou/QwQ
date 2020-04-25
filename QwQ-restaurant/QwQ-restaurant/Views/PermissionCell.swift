//
//  PermissionsCell.swift
//  QwQ-restaurant
//
//  Created by Daniel Wong on 19/4/20.
//

import UIKit

class PermissionCell: UITableViewCell {

    // MARK: View properties
    @IBOutlet var permissionNameLabel: UILabel!
    @IBOutlet var permissionSwitch: UISwitch!

    weak var delegate: PermissionCellDelegate?
    var currentPermission: Permission?

    func setupViews(permission: Permission, isOn: Bool) {
        self.currentPermission = permission
        self.permissionNameLabel.text = permission.localizedDescription
        permissionSwitch.isOn = isOn
    }

    @IBAction func switchChanged(_ sender: UISwitch) {
        guard let currentPermission = currentPermission else {
            return
        }
        if sender.isOn {
            delegate?.addPermission(permission: currentPermission)
        } else {
            delegate?.removePermission(permission: currentPermission)
        }
    }

}

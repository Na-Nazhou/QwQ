//
//  PermissionSelectorViewController.swift
//  QwQ-restaurant
//
//  Created by Daniel Wong on 23/4/20.
//

import UIKit

class PermissionSelectorViewController: UIViewController {

    @IBOutlet var permissionTableView: UITableView!

    weak var delegate: PermissionSelectorDelegate?

    var currentPermissions: [Permission]?
    weak var owner: RoleCell?

    override func viewDidLoad() {
        permissionTableView.delegate = self
        permissionTableView.dataSource = self
        permissionTableView.reloadData()
        super.viewDidLoad()
    }

    override func viewWillDisappear(_ animated: Bool) {
        guard let permissions = currentPermissions, let owner = owner else {
            return
        }
        delegate?.updatePermission(permissions: permissions, for: owner)
        super.viewWillDisappear(animated)
    }

}

extension PermissionSelectorViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Permission.allPermissions.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = permissionTableView.dequeueReusableCell(withIdentifier: Constants.permissionReuseIdentifier,
                                                           for: indexPath)

        guard let permissionCell = cell as? PermissionCell else {
            return cell
        }

        guard let currentPermissions = currentPermissions else {
            return permissionCell
        }

        let permission = Permission.allPermissions[indexPath.row]
        let isOn = currentPermissions.contains(permission)
        permissionCell.setupViews(permission: permission, isOn: isOn)
        permissionCell.delegate = self

        return permissionCell
    }

}

extension PermissionSelectorViewController: PermissionCellDelegate {
    func addPermission(permission: Permission) {
        guard let permissions = currentPermissions else {
            return
        }

        if permissions.contains(permission) {
            return
        }
        currentPermissions?.append(permission)
    }

    func removePermission(permission: Permission) {
        guard let permissions = currentPermissions else {
            return
        }

        currentPermissions = permissions.filter {
            $0 != permission
        }
    }

}

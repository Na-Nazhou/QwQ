//
//  PositionSelectorViewController.swift
//  QwQ-restaurant
//
//  Created by Daniel Wong on 23/4/20.
//

/**
`PositionSelectorViewController` manages roles of staffs of restaurant, and allows setting of roles.
*/

import UIKit

class PositionSelectorViewController: UIViewController {

    @IBOutlet var positionTableView: UITableView!

    weak var delegate: RoleSelectorDelegate?

    var roles: [Role]?
    weak var owner: StaffCell?

    override func viewDidLoad() {
        positionTableView.delegate = self
        positionTableView.dataSource = self
        positionTableView.reloadData()
        super.viewDidLoad()
    }
}

extension PositionSelectorViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let roles = roles else {
            return 0
        }
        return roles.count
    }

    /// Set up available roles for staffs
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = positionTableView.dequeueReusableCell(withIdentifier: Constants.positionReuseIdentifier,
                                                         for: indexPath)

        guard let positionCell = cell as? PositionCell else {
            return cell
        }

        guard let roles = roles else {
            return positionCell
        }

        let role = roles[indexPath.row]
        positionCell.setUpViews(position: role)

        return positionCell
    }

    /// Update staff role to selected role
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let roles = roles, let owner = owner else {
            return
        }
        let selectedRole = roles[indexPath.row].roleName

        self.delegate?.roleSelected(controller: self, selectedRole: selectedRole, owner: owner)
        self.dismiss(animated: true, completion: nil)
    }
}

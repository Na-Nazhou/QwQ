//
//  SetRolesViewController.swift
//  QwQ-restaurant
//
//  Created by Daniel Wong on 23/4/20.
//

import UIKit

class SetRolesViewController: UIViewController {

    // MARK: View properties
    @IBOutlet private var emailTextField: UITextField!
    @IBOutlet private var roleTableView: UITableView!
    @IBOutlet var defaultRolePicker: UIPickerView!

    private var spinner: UIView?

    typealias RoleStorage = FIRRoleStorage

    private var roles: [Role] = []

    override func viewWillAppear(_ animated: Bool) {
        spinner = showSpinner(onView: view)

        RoleStorage.getRestaurantRoles(completion: getRestaurantRolesComplete(roles:),
                                       errorHandler: handleError(error:))

        super.viewWillAppear(animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        roleTableView.delegate = self
        roleTableView.dataSource = self
    }

    @IBAction private func handleBack(_ sender: Any) {
        handleBack()
    }

    private func getRestaurantRolesComplete(roles: [Role]) {
        self.roles = roles
        roleTableView.reloadData()

        removeSpinner(spinner)
    }

    private func handleError(error: Error) {
        removeSpinner(spinner)
        showMessage(title: Constants.errorTitle,
                    message: error.localizedDescription,
                    buttonText: Constants.okayTitle)
    }
}

extension SetRolesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return roles.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = roleTableView.dequeueReusableCell(withIdentifier: Constants.roleReuseIdentifier, for: indexPath)

        guard let roleCell = cell as? RoleCell else {
            return cell
        }

        let role = roles[indexPath.row]

        roleCell.setupViews(role: role)

        return roleCell
    }

    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let toDelete = roles[indexPath.item]

            guard toDelete.roleName != Constants.ownerPermissionsKey else {
                showMessage(title: Constants.cannotDeleteOwnerTitle,
                            message: Constants.cannotDeleteOwnerMessage,
                            buttonText: Constants.okayTitle)
                return
            }

            roles = roles.filter {
                $0 != roles[indexPath.item]
            }

            roleTableView.reloadData()
        }
    }

}

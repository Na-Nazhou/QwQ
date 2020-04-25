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
    @IBOutlet private var roleNameField: UITextField!
    @IBOutlet private var defaultRolePicker: UIPickerView!

    private var spinner: UIView?

    typealias RoleStorage = FIRRoleStorage
    typealias RestaurantStorage = FIRRestaurantStorage

    private var roles: [Role] = []

    private var defaultRole: String {
        return RoleStorage.defaultRole ?? ""
    }

    private var trimmedRoleName: String? {
        return roleNameField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
    }

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
        defaultRolePicker.delegate = self
        defaultRolePicker.dataSource = self
    }

    override func viewWillDisappear(_ animated: Bool) {
        RoleStorage.setRestaurantRoles(roles: roles, errorHandler: handleError(error:))

        let newDefaultRole = roles[defaultRolePicker.selectedRow(inComponent: 0)].roleName
        RestaurantStorage.setDefaultRole(roleName: newDefaultRole, errorHandler: handleError(error:))

        super.viewWillDisappear(animated)
    }

    @IBAction func handleAdd(_ sender: Any) {
        guard let roleName = trimmedRoleName else {
            return
        }

        guard !checkIfAlreadyExists(roleName: roleName) else {
            showMessage(title: Constants.duplicateRoleTitle,
                        message: Constants.duplicateRoleMessage,
                        buttonText: Constants.okayTitle)
            return
        }

        let role = Role(roleName: roleName, permissions: [])

        roles.append(role)
        roleTableView.reloadData()

        roleNameField.text = ""
        refreshPickerViewKeepingCurrentSelection()
    }
    
    @IBAction private func handleBack(_ sender: Any) {
        handleBack()
    }

    private func refreshPickerViewKeepingCurrentSelection() {
        let currentSelection = defaultRolePicker.selectedRow(inComponent: 0)
        defaultRolePicker.reloadAllComponents()
        defaultRolePicker.selectRow(currentSelection, inComponent: 0, animated: false)
    }

    private func getRestaurantRolesComplete(roles: [Role]) {
        self.roles = roles
        roleTableView.reloadData()
        defaultRolePicker.reloadAllComponents()

        for role in roles where role.roleName == defaultRole {
            if let index = roles.firstIndex(of: role) {
                defaultRolePicker.selectRow(index, inComponent: 0, animated: false)
            }
        }
        
        removeSpinner(spinner)
    }

    private func checkIfAlreadyExists(roleName: String) -> Bool {
        for role in roles where role.roleName == roleName {
            return true
        }

        return false
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
        roleCell.delegate = self

        return roleCell
    }

    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            spinner = showSpinner(onView: view)

            let toDelete = roles[indexPath.item]

            guard toDelete.roleName != Constants.ownerPermissionsKey else {
                showMessage(title: Constants.cannotDeleteOwnerTitle,
                            message: Constants.cannotDeleteOwnerMessage,
                            buttonText: Constants.okayTitle)
                return
            }
            RoleStorage.deleteRole(role: toDelete,
                                   completion: didDeleteRole(role:),
                                   errorHandler: handleError(error:))
        }
    }

    private func didDeleteRole(role: Role) {
        roles = roles.filter {
            $0 != role
        }
        removeSpinner(spinner)
        roleTableView.reloadData()
    }
}

extension SetRolesViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return roles.count
    }

    func pickerView(_ pickerView: UIPickerView,
                    viewForRow row: Int,
                    forComponent component: Int,
                    reusing view: UIView?) -> UIView {
        var label = UILabel()
        if let view = view as? UILabel {
            label = view
        }

        label.font = UIFont(name: "Comfortaa", size: 20)
        label.textColor = .white
        label.text = roles[row].roleName
        label.textAlignment = .center

        return label

    }
}

extension SetRolesViewController: RoleCellDelegate {

    func editPermissionsButtonPressed(cell: RoleCell, button: UIButton) {
        let frame = button.frame
        var popoverFrame = cell.convert(frame, to: roleTableView)
        popoverFrame = roleTableView.convert(popoverFrame, to: view)
        popoverFrame.origin.y -= 10

        let permissionSelector = self.storyboard?
            .instantiateViewController(withIdentifier: Constants.permissionSelectorVCIdentifier)
            as? PermissionSelectorViewController

        guard let currentPermissions = cell.currentRole?.permissions else {
            return
        }

        permissionSelector?.modalPresentationStyle = .popover
        permissionSelector?.delegate = self
        permissionSelector?.owner = cell
        permissionSelector?.currentPermissions = currentPermissions

        if let presentationController = permissionSelector?.popoverPresentationController {
            presentationController.permittedArrowDirections = .up
            presentationController.sourceView = self.view
            presentationController.sourceRect = popoverFrame
            presentationController.delegate = self

            if let permissionSelector = permissionSelector {
                present(permissionSelector, animated: true, completion: nil)
            }
        }
    }
}

extension SetRolesViewController: PermissionSelectorDelegate, UIPopoverPresentationControllerDelegate {
    func updatePermission(permissions: [Permission], for cell: RoleCell) {
        guard let currentRole = cell.currentRole else {
            return
        }
        let newRole = Role(roleName: currentRole.roleName, permissions: permissions)
        roles = roles.filter {
            $0 != currentRole
        }
        roles.append(newRole)

        roleTableView.reloadData()
    }
}

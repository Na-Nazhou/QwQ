//
//  AddStaffViewController.swift
//  QwQ-restaurant
//
//  Created by Tan Su Yee on 30/3/20.
//

/**
`AddStaffViewController` manages staffs of restaurant, and allows adding of staffs and setting of staff roles.
 
 It must conform to `StaffCellDelegate` to enable handling of user interaction with staff cells.
 It must conform to `RoleSelectorDelegate` to enable selection of roles for staffs.
*/

import UIKit

class AddStaffViewController: UIViewController {

    // MARK: View properties
    @IBOutlet private var emailTextField: UITextField!
    @IBOutlet private var staffTableView: UITableView!

    private var spinner: UIView?

    typealias RoleStorage = FIRRoleStorage
    typealias PositionStorage = FIRStaffPositionStorage

    private var staffPositions: [StaffPosition] = []
    private var roles: [Role] = []

    private var defaultRole: String {
        return RoleStorage.defaultRole ?? ""
    }

    private var trimmedEmail: String? {
        return emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    override func viewWillAppear(_ animated: Bool) {
        spinner = showSpinner(onView: view)
        PositionStorage.getAllStaffPositions(completion: getAllRestaurantStaffComplete(staffPositions:),
                                             errorHandler: handleError(error:))

        RoleStorage.getRestaurantRoles(completion: getRestaurantRolesComplete(roles:),
                                       errorHandler: handleError(error:))

        super.viewWillAppear(animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        staffTableView.delegate = self
        staffTableView.dataSource = self
    }
    
    /// Add staff if staff info is valid and does not exist
    @IBAction private func handleAdd(_ sender: Any) {
        // Check and validate email
        guard let email = trimmedEmail else {
            return
        }
        
        guard !email.isEmpty else {
            showMessage(title: Constants.missingEmailTitle,
                        message: Constants.missingEmailMessage,
                        buttonText: Constants.okayTitle)
            return
        }
        
        guard ValidationUtilities.validateEmail(email: email) else {
            showMessage(title: Constants.invalidEmailTitle,
                        message: Constants.invalidEmailMessage,
                        buttonText: Constants.okayTitle)
            return
        }

        guard !checkIfAlreadyExists(email: email) else {
            showMessage(title: Constants.duplicateEmailTitle,
                        message: Constants.duplicateEmailMessage,
                        buttonText: Constants.okayTitle)
            return
        }
        
        // Add staff and clear email field
        let staffPosition = StaffPosition(email: email, roleName: defaultRole)

        PositionStorage.updateStaffPosition(staffPosition: staffPosition,
                                            errorHandler: handleError(error:))

        staffPositions.append(staffPosition)
        staffTableView.reloadData()

        emailTextField.text = ""
    }

    @IBAction private func handleBack(_ sender: Any) {
        handleBack()
    }
    
    private func getAllRestaurantStaffComplete(staffPositions: [StaffPosition]) {
        self.staffPositions = staffPositions
        staffTableView.reloadData()

        removeSpinner(spinner)
    }

    private func getRestaurantRolesComplete(roles: [Role]) {
        self.roles = roles
        self.roles.removeAll { (role) -> Bool in
            role.roleName == Constants.ownerPermissionsKey
        }
    }

    private func checkIfAlreadyExists(email: String) -> Bool {
        for position in staffPositions where position.email == email {
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

extension AddStaffViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return staffPositions.count
    }
    
    /// Set up staff position details for all restaurant staffs
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = staffTableView
            .dequeueReusableCell(withIdentifier: Constants.staffReuseIdentifier,
                                 for: indexPath)
        
        guard let staffCell = cell as? StaffCell else {
            return cell
        }
        
        let position = staffPositions[indexPath.row]
        staffCell.setUpViews(staffPosition: position)
        staffCell.delegate = self
        
        return staffCell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }

    /// Allow deletion of staff through swiping staff cell
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let toDelete = staffPositions[indexPath.item]

            guard toDelete.roleName != Constants.ownerPermissionsKey else {
                showMessage(title: Constants.cannotDeleteOwnerTitle,
                            message: Constants.cannotDeleteOwnerMessage,
                            buttonText: Constants.okayTitle)
                return
            }

            PositionStorage.deleteStaffPosition(staffPosition: toDelete)

            staffPositions = staffPositions.filter {
                $0 != staffPositions[indexPath.item]
            }
            staffTableView.reloadData()
        }
    }
}

extension AddStaffViewController: StaffCellDelegate {
    /// Adapted from https://slicode.com/showing-popover-from-tableview-cells/
    func editRoleButtonPressed(cell: StaffCell, button: UIButton) {

        let frame = button.frame
        var popoverFrame = cell.convert(frame, to: staffTableView)
        popoverFrame = staffTableView.convert(popoverFrame, to: view)
        popoverFrame.origin.y -= 10

        let roleSelector = self.storyboard?
            .instantiateViewController(withIdentifier: Constants.positionSelectorVCIdentifier)
            as? RoleSelectorViewController

        roleSelector?.modalPresentationStyle = .popover
        roleSelector?.delegate = self
        roleSelector?.owner = cell
        roleSelector?.roles = roles

        if let presentationController = roleSelector?.popoverPresentationController {
            presentationController.permittedArrowDirections = .up
            presentationController.sourceView = self.view
            presentationController.sourceRect = popoverFrame
            presentationController.delegate = self

            if let roleSelector = roleSelector {
                present(roleSelector, animated: true, completion: nil)
            }
        }
    }
}

extension AddStaffViewController: RoleSelectorDelegate, UIPopoverPresentationControllerDelegate {
    /// Update role of staff according to selection
    func roleSelected(controller: RoleSelectorViewController, selectedRole: String, owner: StaffCell) {
        let staffPosition = StaffPosition(email: owner.email, roleName: selectedRole)

        PositionStorage.updateStaffPosition(staffPosition: staffPosition,
                                            errorHandler: handleError(error:))

        owner.updateRoleLabel(roleName: selectedRole)

    }
}

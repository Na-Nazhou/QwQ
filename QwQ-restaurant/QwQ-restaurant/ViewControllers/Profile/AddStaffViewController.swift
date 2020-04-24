//
//  AddStaffViewController.swift
//  QwQ-restaurant
//
//  Created by Tan Su Yee on 30/3/20.
//

import UIKit

class AddStaffViewController: UIViewController {

    // MARK: View properties
    @IBOutlet private var emailTextField: UITextField!
    @IBOutlet private var staffTableView: UITableView!

    private var spinner: UIView?

    typealias RoleStorage = FIRRoleStorage
    typealias PositionStorage = FIRStaffPositionStorage

    private var defaultRole: String {
        return RoleStorage.defaultRole ?? ""
    }

    private var staffPositions: [StaffPosition] = []
    private var roles: [Role] = []

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

    private func getAllRestaurantStaffComplete(staffPositions: [StaffPosition]) {
        self.staffPositions = staffPositions
        staffTableView.reloadData()

        removeSpinner(spinner)
    }

    private func getRestaurantRolesComplete(roles: [Role]) {
        self.roles = roles
        self.roles.removeAll { (role) -> Bool in
            role.roleName == "Owner"
        }
    }
    
    @IBAction private func handleAdd(_ sender: Any) {
        let trimmedEmail = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
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

        let staffPosition = StaffPosition(email: email, roleName: defaultRole)

        PositionStorage.updateStaffPosition(staffPosition: staffPosition,
                                            errorHandler: handleError(error:))

        staffPositions.append(staffPosition)
        staffTableView.reloadData()
    }

    @IBAction private func handleBack(_ sender: Any) {
        handleBack()
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
        staffPositions.count
    }
    
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
    
    // adapted from https://slicode.com/showing-popover-from-tableview-cells/
    func editRoleButtonPressed(cell: StaffCell, button: UIButton) {

        let frame = button.frame
        var popoverFrame = cell.convert(frame, to: staffTableView)
        popoverFrame = staffTableView.convert(popoverFrame, to: view)
        popoverFrame.origin.y -= 10

        let positionSelector = self.storyboard?
            .instantiateViewController(withIdentifier: Constants.positionSelectorVCIdentifier)
            as? PositionSelectorViewController

        positionSelector?.modalPresentationStyle = .popover
        positionSelector?.delegate = self
        positionSelector?.owner = cell
        positionSelector?.roles = roles

        if let presentationController = positionSelector?.popoverPresentationController {
            presentationController.permittedArrowDirections = .up
            presentationController.sourceView = self.view
            presentationController.sourceRect = popoverFrame
            presentationController.delegate = self

            if let positionSelector = positionSelector {
                present(positionSelector, animated: true, completion: nil)
            }
        }
    }
}

extension AddStaffViewController: RoleSelectorDelegate, UIPopoverPresentationControllerDelegate {
    func roleSelected(controller: PositionSelectorViewController, selectedRole: String, owner: StaffCell) {

        let staffPosition = StaffPosition(email: owner.email, roleName: selectedRole)

        PositionStorage.updateStaffPosition(staffPosition: staffPosition,
                                            errorHandler: handleError(error:))

        owner.updateRoleLabel(roleName: selectedRole)

    }
}

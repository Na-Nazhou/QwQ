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

    typealias PositionStorage = FIRStaffPositionStorage

    private var staffPositions: [StaffPosition] = []

    override func viewWillAppear(_ animated: Bool) {
        spinner = showSpinner(onView: view)
        PositionStorage.getAllRestaurantStaff(completion: getAllRestaurantStaffComplete(staffPositions:),
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

        removeSpinner(spinner
        )
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

        staffPositions.append(StaffPosition(email: email, roleName: "Server"))
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
        
        return staffCell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }

    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            staffPositions = staffPositions.filter {
                $0 != staffPositions[indexPath.item]
            }
            staffTableView.reloadData()
        }
    }
}

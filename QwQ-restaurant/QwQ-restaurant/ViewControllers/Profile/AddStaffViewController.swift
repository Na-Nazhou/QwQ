//
//  AddStaffViewController.swift
//  QwQ-restaurant
//
//  Created by Tan Su Yee on 30/3/20.
//

import UIKit

class AddStaffViewController: UIViewController {
    var staffEmails: [String] = []
    
    @IBOutlet private var emailTextField: UITextField!
    @IBOutlet private var staffTableView: UITableView!
    
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
        
        staffEmails.append(email)
        staffTableView.reloadData()
    }
    
    @IBAction private func handleBack(_ sender: Any) {
        handleBack()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        staffTableView.delegate = self
        staffTableView.dataSource = self
    }
}

extension AddStaffViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        staffEmails.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = staffTableView
            .dequeueReusableCell(withIdentifier: Constants.staffReuseIdentifier,
                                 for: indexPath)
        
        guard let staffCell = cell as? StaffCell else {
            return cell
        }
        
        let staffEmail = staffEmails[indexPath.row]
        staffCell.setUpViews(staffEmail: staffEmail)
        
        return staffCell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            staffEmails = staffEmails.filter {
                $0 != staffEmails[indexPath.item]
            }
            staffTableView.reloadData()
        }
    }
}

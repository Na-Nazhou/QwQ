//
//  EditProfileViewController.swift
//  QwQ
//
//  Created by Daniel Wong on 14/3/20.
//

import UIKit

class EditProfileViewController: UIViewController, ProfileDelegate {

    @IBOutlet private var nameTextField: UITextField!
    @IBOutlet private var contactTextField: UITextField!
    @IBOutlet private var emailTextField: UITextField!

    let profileStorage: ProfileStorage
    var uid: String?

    init() {
        profileStorage = FBProfileStorage()
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        profileStorage = FBProfileStorage()
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        profileStorage.setDelegate(delegate: self)
        profileStorage.getCustomerInfo()
    }

    func getCustomerInfoComplete(customer: Customer) {
        self.uid = customer.uid
        self.nameTextField.text = customer.name
        self.contactTextField.text = customer.contact
        self.emailTextField.text = customer.email
    }

    @IBAction private func saveButton(_ sender: Any) {
        let trimmedName = nameTextField.text?.trimmingCharacters(in: .newlines)
        let trimmedContact = contactTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedEmail = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)

        guard checkIfAllFieldsAreFilled() else {
            showMessage(title: "Error:", message: "Please fill in all the fields!", buttonText: "Okay")
            return
        }

        guard let uid = uid, let name = trimmedName,
            let contact = trimmedContact, let email = trimmedEmail else {
                return
        }

        profileStorage.updateCustomerInfo(customer: Customer(uid: uid, name: name, email: email, contact: contact))
    }

    func updateComplete() {
        showMessage(title: "Update complete",
                    message: "Please delete this when popVC is implemented.", buttonText: "Thanks!")
        // go back to previous screen
    }

    func showMessage(title: String, message: String, buttonText: String) {
        let message = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let closeDialogAction = UIAlertAction(title: buttonText, style: .default)
        message.addAction(closeDialogAction)

        self.present(message, animated: true)
    }

    private func checkIfAllFieldsAreFilled() -> Bool {
        if let name = nameTextField.text,
            let contact = contactTextField.text,
            let email = emailTextField.text {
            return !name.trimmingCharacters(in: .newlines).isEmpty &&
                !contact.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
                !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        }
        return false
    }

}

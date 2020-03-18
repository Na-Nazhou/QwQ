//
//  SignUpViewController.swift
//  QwQ
//
//  Created by Tan Su Yee on 13/3/20.
//

import UIKit

class SignUpViewController: UIViewController, AuthDelegate {

    @IBOutlet private var nameTextField: UITextField!
    @IBOutlet private var contactTextField: UITextField!
    @IBOutlet private var emailTextField: UITextField!
    @IBOutlet private var passwordTextField: UITextField!

    let auth: Authenticator

    init() {
        self.auth = FBAuthenticator()
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        self.auth = FBAuthenticator()
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        auth.setDelegate(delegate: self)

        self.hideKeyboardWhenTappedAround()
    }

    @IBAction private func handleBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction private func submitButton(_ sender: Any) {

        let trimmedName = nameTextField.text?.trimmingCharacters(in: .newlines)
        let trimmedContact = contactTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedEmail = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedPassword = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)

        guard checkIfAllFieldsAreFilled() else {
            showMessage(title: Constants.missingFieldsTitle,
                        message: Constants.missingFieldsMessage,
                        buttonText: Constants.okayTitle,
                        buttonAction: nil)
            return
        }

        guard let name = trimmedName, let contact = trimmedContact,
            let email = trimmedEmail, let password = trimmedPassword else {
                return
        }

        guard ValidationUtilities.validateEmail(email: email) else {
            showMessage(title: Constants.invalidEmailTitle,
                        message: Constants.invalidEmailMessage,
                        buttonText: Constants.okayTitle,
                        buttonAction: nil)
            return
        }

        guard ValidationUtilities.validateContact(contact: contact) else {
            showMessage(title: Constants.invalidContactTitle,
                        message: Constants.invalidContactMessage,
                        buttonText: Constants.okayTitle,
                        buttonAction: nil)
            return
        }

        auth.signup(name: name, contact: contact, email: email, password: password)
    }

    func authCompleted() {
        performSegue(withIdentifier: Constants.signUpCompletedSegue, sender: self)
    }

    private func checkIfAllFieldsAreFilled() -> Bool {
        if let name = nameTextField.text,
            let contact = contactTextField.text,
            let email = emailTextField.text,
            let password = passwordTextField.text {
            return !name.trimmingCharacters(in: .newlines).isEmpty &&
                !contact.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
                !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
                !password.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        }
        return false
    }

}

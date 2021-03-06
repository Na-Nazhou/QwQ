//
//  SignUpViewController.swift
//  QwQ
//
//  Created by Tan Su Yee on 13/3/20.
//

/**
`SignUpViewController` manages sign ups of customers.
*/

import UIKit

class SignUpViewController: UIViewController {

    // MARK: View properties
    @IBOutlet private var nameTextField: UITextField!
    @IBOutlet private var contactTextField: UITextField!
    @IBOutlet private var emailTextField: UITextField!
    @IBOutlet private var passwordTextField: UITextField!

    private var spinner: UIView?

    typealias Profile = FIRProfileStorage
    typealias Auth = FIRAuthenticator

    override func viewDidLoad() {
        super.viewDidLoad()

        self.registerObserversForKeyboard()
        self.hideKeyboardWhenTappedAround()
    }

    @IBAction private func handleBack(_ sender: Any) {
        handleBack()
    }
    
    /// Sign up user if user details are valid
    @IBAction private func handleSubmit(_ sender: Any) {
        // Check and validate all fields
        let trimmedName = nameTextField.text?.trimmingCharacters(in: .newlines)
        let trimmedContact = contactTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedEmail = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedPassword = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)

        guard checkIfAllFieldsAreFilled() else {
            showMessage(title: Constants.missingFieldsTitle,
                        message: Constants.missingFieldsMessage,
                        buttonText: Constants.okayTitle)
            return
        }

        guard let name = trimmedName, let contact = trimmedContact,
            let email = trimmedEmail, let password = trimmedPassword else {
                return
        }

        guard ValidationUtilities.validateEmail(email: email) else {
            showMessage(title: Constants.invalidEmailTitle,
                        message: Constants.invalidEmailMessage,
                        buttonText: Constants.okayTitle)
            return
        }

        guard ValidationUtilities.validateContact(contact: contact) else {
            showMessage(title: Constants.invalidContactTitle,
                        message: Constants.invalidContactMessage,
                        buttonText: Constants.okayTitle)
            return
        }

        spinner = showSpinner(onView: view)

        // Sign up user and log user in
        let signupDetails = SignupDetails(name: name, contact: contact)
        let authDetails = AuthDetails(email: email, password: password)

        Auth.signup(signupDetails: signupDetails,
                    authDetails: authDetails,
                    completion: signUpComplete,
                    errorHandler: handleError(error:))
    }

    private func signUpComplete() {
        /* Email verification code - to be enabled only in production application
        performSegue(withIdentifier: Constants.emailNotVerifiedSegue, sender: self)
        return
        */
        Profile.getCustomerInfo(completion: getCustomerInfoComplete(customer:),
                                errorHandler: handleError(error:))
    }

    private func getCustomerInfoComplete(customer: Customer) {
        CustomerPostLoginSetupManager.setUp(asIdentity: customer)
        removeSpinner(spinner)
        performSegue(withIdentifier: Constants.signUpCompletedSegue, sender: self)
    }

    private func handleError(error: Error) {
        showMessage(title: Constants.errorTitle, message: error.localizedDescription, buttonText: Constants.okayTitle)
        removeSpinner(spinner)
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

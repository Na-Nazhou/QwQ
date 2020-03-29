//
//  FBLoginViewController.swift
//  QwQ
//
//  Created by Daniel Wong on 28/3/20.
//

import UIKit
import FacebookCore
import FacebookLogin

class FBLoginViewController: UIViewController {

    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var contactTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!

    typealias Profile = FIRProfileStorage

    var spinner: UIView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        performFBLogin()
    }

    @IBAction func submitButton(_ sender: Any) {
        let trimmedName = nameTextField.text?.trimmingCharacters(in: .newlines)
        let trimmedContact = contactTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedEmail = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)

        guard checkIfAllFieldsAreFilled() else {
            showMessage(title: Constants.missingFieldsTitle,
                        message: Constants.missingFieldsMessage,
                        buttonText: Constants.okayTitle)
            return
        }

        guard let name = trimmedName, let contact = trimmedContact,
            let email = trimmedEmail else {
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

        let authDetails = AuthDetails(email: email, password: "")
        let signupDetails = SignupDetails(name: name, contact: contact)

        Profile.createInitialCustomerProfile(uid: email,
                                             signupDetails: signupDetails,
                                             authDetails: authDetails,
                                             errorHandler: handleError(error:))
        authCompleted()

    }

    func performFBLogin() {
        let loginManager = LoginManager()
        loginManager.logIn(permissions: [.publicProfile, .email], viewController: self) { (result) in
            self.fbLoginManagerComplete(result: result)
        }
    }

    func fbLoginManagerComplete(result: LoginResult) {
        switch result {
        case .cancelled:
            showMessage(title: Constants.errorTitle,
                        message: Constants.loginCancelledMessage,
                        buttonText: Constants.okayTitle,
                        buttonAction: returnToLogin(_:))

        case .failed(let error):
            showMessage(title: Constants.errorTitle,
                        message: error.localizedDescription,
                        buttonText: Constants.okayTitle,
                        buttonAction: returnToLogin(_:))

        case .success(_, let declinedPermissions, _):
            if !declinedPermissions.isEmpty {
                showMessage(title: Constants.errorTitle,
                            message: Constants.fbLoginPermissionsMessage,
                            buttonText: Constants.okayTitle,
                            buttonAction: returnToLogin(_:))
                let loginManager = LoginManager()
                loginManager.logOut()
                return
            }
            authCompleted()
        }
    }

    func authCompleted() {
        spinner = showSpinner(onView: view)
        getUserDetails()
    }

    func getUserDetails() {
        let connection = GraphRequestConnection()
        let request = GraphRequest(graphPath: "/me", parameters: ["fields": "name, email"])

        connection.add(request) { (_, result, error) in
            if let error = error {
                self.showMessage(title: Constants.errorTitle,
                                 message: error.localizedDescription,
                                 buttonText: Constants.errorTitle)
            }
            
            if let result = result as? [String: String], let name = result["name"], let email = result["email"] {

                Profile.currentUID = email
                Profile.currentAuthType = AuthTypes.Facebook

                Profile.getCustomerInfo(completion: self.getUserInfoComplete(customer:)) { (_) in
                    self.removeSpinner(self.spinner)
                    self.nameTextField.text = name
                    self.emailTextField.text = email
                }
            }
        }

        connection.start()
    }

    func getUserInfoComplete(customer: Customer) {
        CustomerPostLoginSetupManager.setUp(asIdentity: customer)
        removeSpinner(spinner)
        performSegue(withIdentifier: Constants.fbLoginCompletedSegue, sender: self)
    }

    private func handleError(error: Error) {
        showMessage(title: Constants.errorTitle, message: error.localizedDescription, buttonText: Constants.okayTitle)
        removeSpinner(spinner)
    }

    private func returnToLogin(_: UIAlertAction?) {
        self.navigationController?.popViewController(animated: true)
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

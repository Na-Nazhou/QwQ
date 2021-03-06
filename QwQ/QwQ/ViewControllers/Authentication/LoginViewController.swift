//
//  LoginViewController.swift
//  QwQ
//
//  Created by Tan Su Yee on 13/3/20.
//  Copyright © 2020 Appfish. All rights reserved.
//

/**
`LoginViewController` manages logins of customers through email or facebook.
*/

import UIKit
import FacebookLogin
import FacebookCore

class LoginViewController: UIViewController {

    // MARK: View properties
    @IBOutlet private var emailTextField: UITextField!
    @IBOutlet private var passwordTextField: UITextField!

    private var spinner: UIView?

    typealias Profile = FIRProfileStorage
    typealias Auth = FIRAuthenticator

    override func viewDidLoad() {
        super.viewDidLoad()

        spinner = showSpinner(onView: view)

        if Auth.checkIfAlreadyLoggedIn() {
            firAlreadyLoggedIn()
        } else if AccessToken.current != nil {
            fbAlreadyLoggedIn()
        } else {
            removeSpinner(spinner)
        }

        self.registerObserversForKeyboard()
        self.hideKeyboardWhenTappedAround()
    }

    /// Log user in if user is valid
    @IBAction private func handleLogin(_ sender: Any) {
        // Check and validate all fields
        let trimmedEmail = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedPassword = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)

        guard let email = trimmedEmail, let password = trimmedPassword else {
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

        guard !password.isEmpty else {
            showMessage(title: Constants.missingPasswordTitle,
                        message: Constants.missingPasswordMessage,
                        buttonText: Constants.okayTitle)
            return
        }
        
        // Log user in
        let authDetails = AuthDetails(email: email, password: password)
        Auth.login(authDetails: authDetails, completion: authCompleted, errorHandler: handleError(error:))

        spinner = showSpinner(onView: view)
    }
    
    @IBAction private func unwindToLogin(_ unwindSegue: UIStoryboardSegue) {
        removeSpinner(spinner)
    }

    private func firAlreadyLoggedIn() {
        Auth.initAlreadyLoggedInUser()
        authCompleted()
    }

    private func fbAlreadyLoggedIn() {
        let connection = GraphRequestConnection()
        let request = GraphRequest(graphPath: "/me", parameters: ["fields": "email"])

        // Get current user
        connection.add(request) { (_, result, error) in
            if let error = error {
                self.showMessage(title: Constants.errorTitle,
                                 message: error.localizedDescription,
                                 buttonText: Constants.errorTitle)
            }

            if let result = result as? [String: String], let email = result["email"] {
                Profile.currentUID = email
                Profile.currentAuthType = AuthTypes.Facebook
                self.authCompleted()
            }
        }
        connection.start()
    }

    private func authCompleted() {
        /* Email verification code - to be enabled only in production application
        guard Auth.checkIfEmailVerified() else {
            Auth.sendVerificationEmail(errorHandler: handleError(error:))
            performSegue(withIdentifier: Constants.loginEmailNotVerifiedSegue, sender: self)
            removeSpinner(spinner)
            return
        }
        */
        Profile.getCustomerInfo(completion: getCustomerInfoComplete(customer:),
                                errorHandler: handleError(error:))
    }

    private func getCustomerInfoComplete(customer: Customer) {
        CustomerPostLoginSetupManager.setUp(asIdentity: customer)
        removeSpinner(spinner)
        performSegue(withIdentifier: Constants.loginCompletedSegue, sender: self)
    }

    private func handleError(error: Error) {
        showMessage(title: Constants.errorTitle, message: error.localizedDescription, buttonText: Constants.okayTitle)
        removeSpinner(spinner)
    }
}

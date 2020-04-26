//
//  LoginViewController.swift
//  QwQ-restaurant
//
//  Created by Tan Su Yee on 14/3/20.
//

/**
`LoginViewController` manages logins of staffs or restaurants.
 
 It must conform to `LoginLogicDelegate` so that user can be logged in and directed to the correct page according to
 profile completion status.
*/

import UIKit

class LoginViewController: UIViewController {

    // MARK: View properties
    @IBOutlet private var emailTextField: UITextField!
    @IBOutlet private var passwordTextField: UITextField!

    private var spinner: UIView?

    typealias Auth = FIRAuthenticator

    private var trimmedEmail: String? {
        return emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var trimmedPassword: String? {
        return passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        spinner = showSpinner(onView: view)
        if Auth.checkIfAlreadyLoggedIn() {
            alreadyLoggedIn()
        } else {
            removeSpinner(spinner)
        }

        self.registerObserversForKeyboard()
        self.hideKeyboardWhenTappedAround()
    }

    @IBAction private func unwindToLogin(_ unwindSegue: UIStoryboardSegue) {
    }

    /// Log user in if user is valid
    @IBAction private func handleLogin(_ sender: Any) {
        // Check and validate all fields
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

        spinner = showSpinner(onView: view)
        
        // Log user in
        let authDetails = AuthDetails(email: email, password: password)
        beginLogin(authDetails: authDetails)
    }

    private func beginLogin(authDetails: AuthDetails) {
        let loginLogic = FIRLoginLogic()
        loginLogic.delegate = self
        loginLogic.beginLogin(authDetails: authDetails)
    }

    private func alreadyLoggedIn() {
        Auth.initAlreadyLoggedInUser()
        let loginLogic = FIRLoginLogic()
        loginLogic.delegate = self
        loginLogic.getStaffInfo()
    }
}

extension LoginViewController: LoginLogicDelegate {
    /// Switch to home page once login is successful
    func loginComplete() {
        removeSpinner(spinner)
        performSegue(withIdentifier: Constants.loginCompletedSegue, sender: self)
    }

    /// Switch to email verification page if email is not verified
    func emailNotVerified() {
        removeSpinner(spinner)
        performSegue(withIdentifier: Constants.emailNotVerifiedSegue, sender: self)
    }

    /// Switch to no restaurant assigned page if staff has no restaurant assigned
    func noAssignedRestaurant() {
        removeSpinner(spinner)
        performSegue(withIdentifier: Constants.noAssignedRestaurantSegue, sender: self)
    }

    /// Switch to no role assigned page if staff has no role assigned
    func noAssignedRole() {
        removeSpinner(spinner)
        handleError(error: PermissionError.PermissionsNotInitialised)
    }

    /// Show error message in an alert box
    func handleError(error: Error) {
        showMessage(title: Constants.errorTitle, message: error.localizedDescription, buttonText: Constants.okayTitle)
        removeSpinner(spinner)
    }
}

//
//  LoginViewController.swift
//  QwQ-restaurant
//
//  Created by Tan Su Yee on 14/3/20.
//

import UIKit

class LoginViewController: UIViewController, LoginLogicDelegate {

    // MARK: View properties
    @IBOutlet private var emailTextField: UITextField!
    @IBOutlet private var passwordTextField: UITextField!

    var spinner: UIView?

    typealias Profile = FIRRestaurantStorage
    typealias Auth = FIRAuthenticator

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

    @IBAction private func loginButton(_ sender: Any) {
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

        spinner = showSpinner(onView: view)
        
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
    
    func loginComplete() {
        removeSpinner(spinner)
        performSegue(withIdentifier: Constants.loginCompletedSegue, sender: self)
    }

    func emailNotVerified() {
        removeSpinner(spinner)
        performSegue(withIdentifier: Constants.emailNotVerifiedSegue, sender: self)
    }

    func handleError(error: Error) {
        showMessage(title: Constants.errorTitle, message: error.localizedDescription, buttonText: Constants.okayTitle)
        removeSpinner(spinner)
    }

}

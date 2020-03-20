//
//  LoginViewController.swift
//  QwQ
//
//  Created by Tan Su Yee on 13/3/20.
//  Copyright © 2020 Appfish. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    typealias Profile = FBProfileStorage
    typealias Auth = FBAuthenticator

    @IBOutlet private var emailTextField: UITextField!
    @IBOutlet private var passwordTextField: UITextField!

    var spinner: UIView?

    override func viewDidLoad() {
        super.viewDidLoad()

        spinner = showSpinner(onView: view)
        Auth.checkIfAlreadyLoggedIn(completion: authCompleted, failure: notYetLoggedIn)

        self.registerObserversForKeyboard()
        self.hideKeyboardWhenTappedAround()
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
        let authDetails = AuthDetails(email: email, password: password)
        Auth.login(authDetails: authDetails, completion: authCompleted, errorHandler: handleError(error:))

        spinner = showSpinner(onView: view)

    }

    @IBAction private func unwindToLogin(_ unwindSegue: UIStoryboardSegue) {
    }

    private func authCompleted() {
        Profile.getCustomerInfo(completion: getCustomerInfoComplete(customer:),
                                errorHandler: handleError(error:))
    }

    private func notYetLoggedIn() {
        removeSpinner(spinner)
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

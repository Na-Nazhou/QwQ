//
//  LoginViewController.swift
//  QwQ
//
//  Created by Tan Su Yee on 13/3/20.
//  Copyright © 2020 Appfish. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, AuthDelegate, ProfileDelegate {

    let auth: Authenticator

    @IBOutlet private var emailTextField: UITextField!
    @IBOutlet private var passwordTextField: UITextField!

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
        auth.checkIfAlreadyLoggedIn()

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
                        buttonText: Constants.okayTitle,
                        buttonAction: nil)
            return
        }

        guard ValidationUtilities.validateEmail(email: email) else {
            showMessage(title: Constants.invalidEmailTitle,
                        message: Constants.invalidEmailMessage,
                        buttonText: Constants.okayTitle,
                        buttonAction: nil)
            return
        }

        guard !password.isEmpty else {
            showMessage(title: Constants.missingPasswordTitle,
                        message: Constants.missingPasswordMessage,
                        buttonText: Constants.okayTitle,
                        buttonAction: nil)
            return
        }

        auth.login(email: email, password: password)

    }

    func authCompleted() {
        let profile = FBProfileStorage()
        profile.setDelegate(delegate: self)

        profile.getCustomerInfo()
    }

    func getCustomerInfoComplete(customer: Customer) {
        CustomerPostLoginSetupManager.setUp(asIdentity: customer)
        performSegue(withIdentifier: Constants.loginCompletedSegue, sender: self)
    }

    func updateComplete() {
        fatalError("This method is not used here.")
    }

    @IBAction private func unwindToLogin(_ unwindSegue: UIStoryboardSegue) {
    }
}

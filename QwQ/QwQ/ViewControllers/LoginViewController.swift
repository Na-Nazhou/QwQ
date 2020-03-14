//
//  LoginViewController.swift
//  QwQ
//
//  Created by Tan Su Yee on 13/3/20.
//  Copyright © 2020 Appfish. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, AuthDelegate {

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

        auth.setDelegate(view: self)

        self.hideKeyboardWhenTappedAround()
    }

    @IBAction private func loginButton(_ sender: Any) {

        let trimmedEmail = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedPassword = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)

        guard let email = trimmedEmail, let password = trimmedPassword else {
            return
        }

        guard !email.isEmpty else {
            showMessage(title: Constants.missingEmailTitle, message: Constants.missingEmailMessage, buttonText: Constants.okayButton)
            return
        }

        guard LoginUtilities.validateEmail(email: email) else {
            showMessage(title: Constants.invalidEmailTitle, message: Constants.invalidEmailMessage, buttonText: Constants.okayButton)
            return
        }

        guard !password.isEmpty else {
            showMessage(title: Constants.missingPasswordTitle, message: Constants.missingPasswordMessage, buttonText: Constants.okayButton)
            return
        }

        auth.login(email: email, password: password)

    }

    func showMessage(title: String, message: String, buttonText: String) {
        let message = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let closeDialogAction = UIAlertAction(title: buttonText, style: .default)
        message.addAction(closeDialogAction)

        self.present(message, animated: true)
    }

    func authSucceeded() {
        performSegue(withIdentifier: Constants.loginCompletedSegue, sender: self)
    }

}

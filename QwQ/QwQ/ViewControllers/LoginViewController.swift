//
//  ViewController.swift
//  QwQ
//
//  Created by Tan Su Yee on 11/3/20.
//  Copyright © 2020 Appfish. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet private var emailTextField: UITextField!
    @IBOutlet private var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction private func handleLogin(_ sender: Any) {
        let auth = FBAuthenticator()
        var uid = ""

        guard var email = emailTextField.text else {
            showMessage(title: "Missing Email", message: "Please provide a valid email.", buttonMessage: "Okay")
            return
        }

        guard validateEmail(email: email) else {
            showMessage(title: "Invalid Email", message: "Please provide a proper email.", buttonMessage: "Okay")
            return
        }

        guard var password = passwordTextField.text else {
            showMessage(title: "Missing Password", message: "Please provide a valid password.", buttonMessage: "Okay")
            return
        }
        email = email.trimmingCharacters(in: .whitespacesAndNewlines)
        password = password.trimmingCharacters(in: .whitespacesAndNewlines)

        do {
            uid = try auth.login(email: email, password: password)
        } catch LoginError.firebaseError(let errorMessage) {
            showMessage(title: "Error", message: "An internal error occured: \(errorMessage)", buttonMessage: "Okay")
        } catch {
            showMessage(title: "Oops!", message: "Something went wrong.", buttonMessage: "Okay")
        }

        print(uid)

    }

    func showMessage(title: String, message: String, buttonMessage: String) {
        let message = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let closeDialogAction = UIAlertAction(title: buttonMessage, style: .default)
        message.addAction(closeDialogAction)

        self.present(message, animated: true)
    }

    /// taken from https://emailregex.com/
    private func validateEmail(email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }

}

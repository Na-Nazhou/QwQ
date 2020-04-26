//
//  ForgotPasswordViewController.swift
//  QwQ
//
//  Created by Tan Su Yee on 31/3/20.
//

/**
`ForgotPasswordViewController` manages password resets of user through email.
*/

import UIKit

class ForgotPasswordViewController: UIViewController {

    // MARK: View properties
    @IBOutlet private var emailTextField: UITextField!

    private var spinner: UIView?

    typealias Auth = FIRAuthenticator

    override func viewDidLoad() {
        super.viewDidLoad()

        self.hideKeyboardWhenTappedAround()
    }

    /// Send password reset email to user email and show success or failure emssage
    @IBAction private func handleResetPassword(_ sender: Any) {
        let trimmedEmail = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)

        guard let email = trimmedEmail else {
            showMessage(title: Constants.invalidEmailTitle,
                        message: Constants.invalidEmailMessage,
                        buttonText: Constants.okayTitle)
            return
        }

        spinner = showSpinner(onView: view)
        Auth.resetPassword(for: email, completion: emailSent, errorHandler: handleError(error:))
    }
    
    @IBAction private func handleBack(_ sender: Any) {
        handleBack()
    }
    
    private func emailSent() {
        removeSpinner(spinner)
        showMessage(title: Constants.resetPasswordTitle,
                    message: Constants.resetPasswordMessage,
                    buttonText: Constants.okayTitle)
    }

    private func handleError(error: Error) {
        showMessage(title: Constants.errorTitle, message: error.localizedDescription, buttonText: Constants.okayTitle)
        removeSpinner(spinner)
    }
}

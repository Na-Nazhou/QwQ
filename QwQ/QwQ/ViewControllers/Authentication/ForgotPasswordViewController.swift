//
//  ForgotPasswordViewController.swift
//  QwQ
//
//  Created by Tan Su Yee on 31/3/20.
//

import UIKit

class ForgotPasswordViewController: UIViewController {

    typealias Auth = FIRAuthenticator

    var spinner: UIView?
    
    @IBOutlet private var emailTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.hideKeyboardWhenTappedAround()
    }

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
    
    @IBAction func handleBack(_ sender: Any) {
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

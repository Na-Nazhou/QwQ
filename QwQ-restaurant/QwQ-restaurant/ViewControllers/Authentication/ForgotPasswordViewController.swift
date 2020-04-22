//
//  ForgotPasswordViewController.swift
//  QwQ
//
//  Created by Tan Su Yee on 31/3/20.
//

import UIKit

class ForgotPasswordViewController: UIViewController {

    // MARK: View properties
    @IBOutlet private var emailTextField: UITextField!

    private var spinner: UIView?

    typealias Auth = FIRAuthenticator

    private var trimmedEmail: String? {
        return emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction private func handleResetPassword(_ sender: Any) {
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

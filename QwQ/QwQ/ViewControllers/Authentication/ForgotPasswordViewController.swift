//
//  ForgotPasswordViewController.swift
//  QwQ
//
//  Created by Tan Su Yee on 31/3/20.
//

import UIKit

class ForgotPasswordViewController: UIViewController {
    var spinner: UIView?
    
    @IBOutlet private var emailTextField: UITextField!
    
    @IBAction private func handleResetPassword(_ sender: Any) {
        spinner = showSpinner(onView: view)
        removeSpinner(spinner)
        showMessage(title: Constants.resetPasswordTitle,
                    message: Constants.resetPasswordMessage,
                    buttonText: Constants.okayTitle)
    }
    
    @IBAction func handleBack(_ sender: Any) {
        handleBack()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

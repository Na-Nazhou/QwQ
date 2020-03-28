//
//  FBLoginViewController.swift
//  QwQ
//
//  Created by Daniel Wong on 28/3/20.
//

import UIKit
import FacebookCore
import FacebookLogin

class FBLoginViewController: UIViewController {

    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var contactTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        performFBLogin()
    }

    func performFBLogin() {
        let loginManager = LoginManager()
        loginManager.logIn(permissions: [.publicProfile, .email], viewController: self) { (result) in
            self.fbLoginManagerComplete(result: result)
        }
    }

    func fbLoginManagerComplete(result: LoginResult) {
        switch result {
        case .cancelled:
            showMessage(title: Constants.errorTitle,
                        message: Constants.loginCancelledMessage,
                        buttonText: Constants.okayTitle,
                        buttonAction: returnToLogin(_:))

        case .failed(let error):
            showMessage(title: Constants.errorTitle,
                        message: error.localizedDescription,
                        buttonText: Constants.okayTitle,
                        buttonAction: returnToLogin(_:))

        case .success(_, let declinedPermissions, _):
            if !declinedPermissions.isEmpty {
                showMessage(title: Constants.errorTitle,
                            message: Constants.fbLoginPermissionsMessage,
                            buttonText: Constants.okayTitle)
                returnToLogin(nil)
                return
            }
            authCompleted()
        }
    }

    func getUserDetails() {
        let connection = GraphRequestConnection()
        let request = GraphRequest(graphPath: "/me", parameters: ["fields": "name, email"])

        connection.add(request) { (response, result, error) in
            if let error = error {
                self.showMessage(title: Constants.errorTitle, message: error.localizedDescription, buttonText: Constants.errorTitle)
            }

            if let result = result as? [String: String], let name = result["name"], let email = result["email"] {
            }
        }
    }

    func authCompleted() {
        // check if user profile exists first
    }

    private func returnToLogin(_: UIAlertAction?) {
        self.navigationController?.popViewController(animated: true)
    }

}

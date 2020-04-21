//
//  ProfileViewController.swift
//  QwQ
//
//  Created by Tan Su Yee on 13/3/20.
//

import UIKit
import FacebookLogin

class ProfileViewController: UIViewController {

    // MARK: View properties
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var contactLabel: UILabel!
    @IBOutlet private var emailLabel: UILabel!
    @IBOutlet private var profileImageView: UIImageView!

    var spinner: UIView?
    
    typealias Profile = FIRProfileStorage
    typealias Auth = FIRAuthenticator

    override func viewWillAppear(_ animated: Bool) {
        spinner = showSpinner(onView: view)
        Profile.getCustomerInfo(completion: getCustomerInfoComplete(customer:),
                                errorHandler: handleError(error:))
        super.viewWillAppear(animated)
    }

    @IBAction private func logoutButton(_ sender: Any) {
        guard let authType = Profile.currentAuthType else {
            return
        }
        if authType == AuthTypes.Firebase {
            Auth.logout(completion: {
                self.logoutComplete()
            }) { (error) in
                self.showMessage(title: Constants.errorTitle,
                                 message: error.localizedDescription,
                                 buttonText: Constants.okayTitle)
            }
        } else if authType == AuthTypes.Facebook {
            let loginManager = LoginManager()
            loginManager.logOut()
            logoutComplete()
        }

    }

    private func getCustomerInfoComplete(customer: Customer) {
        self.nameLabel.text = customer.name
        self.contactLabel.text = customer.contact
        self.emailLabel.text = customer.email
        
        Profile.getCustomerProfilePic(uid: customer.uid, placeholder: profileImageView)

        removeSpinner(spinner)
    }

    private func logoutComplete() {
        CustomerPostLoginSetupManager.tearDown()
        performSegue(withIdentifier: Constants.logoutSegue, sender: self)
    }

    private func handleError(error: Error) {
        showMessage(title: Constants.errorTitle, message: error.localizedDescription, buttonText: Constants.okayTitle)
    }

}

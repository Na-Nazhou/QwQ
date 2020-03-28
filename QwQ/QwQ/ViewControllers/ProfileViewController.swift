//
//  ProfileViewController.swift
//  QwQ
//
//  Created by Tan Su Yee on 13/3/20.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var contactLabel: UILabel!
    @IBOutlet private var emailLabel: UILabel!

    @IBOutlet private var profileImageView: UIImageView!
    
    typealias Profile = FIRProfileStorage
    typealias Auth = FIRAuthenticator

    var spinner: UIView?

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        spinner = showSpinner(onView: view)
        Profile.getCustomerInfo(completion: getCustomerInfoComplete(customer:),
                                errorHandler: handleError(error:))
    }

    @IBAction private func logoutButton(_ sender: Any) {
        Auth.logout(completion: {
            self.logoutComplete()
        }) { (error) in
            self.showMessage(title: Constants.errorTitle,
                             message: error.localizedDescription,
                             buttonText: Constants.okayTitle)
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

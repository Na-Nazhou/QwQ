//
//  ProfileViewController.swift
//  QwQ
//
//  Created by Tan Su Yee on 13/3/20.
//

import UIKit

class ProfileViewController: UIViewController, AuthDelegate, ProfileDelegate {

    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var contactLabel: UILabel!
    @IBOutlet private var emailLabel: UILabel!
    @IBOutlet private var profileImageView: UIImageView!
    
    let profileStorage: ProfileStorage
    let auth: Authenticator

    init() {
        profileStorage = FBProfileStorage()
        auth = FBAuthenticator()
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        profileStorage = FBProfileStorage()
        auth = FBAuthenticator()
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        profileStorage.setDelegate(delegate: self)
        auth.setDelegate(delegate: self)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        profileStorage.getCustomerInfo()
    }

    @IBAction private func logoutButton(_ sender: Any) {
        auth.logout()
    }

    func getCustomerInfoComplete(customer: Customer) {
        self.nameLabel.text = customer.name
        self.contactLabel.text = customer.contact
        self.emailLabel.text = customer.email
    }

    func authCompleted() {
        CustomerPostLoginSetupManager.tearDown()
        performSegue(withIdentifier: Constants.logoutSegue, sender: self)
    }

    func updateComplete() {
        fatalError("This method is not implemented here.")
    }

}

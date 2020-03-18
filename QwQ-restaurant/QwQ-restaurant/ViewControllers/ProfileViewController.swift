//
//  ProfileViewController.swift
//  QwQ-restaurant
//
//  Created by Tan Su Yee on 14/3/20.
//  Copyright © 2020 Appfish. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, AuthDelegate {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var menuLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var contactLabel: UILabel!
    
    let auth: Authenticator

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
        auth.setDelegate(delegate: self)
    }

    @IBAction func logoutButton(_ sender: Any) {
        auth.logout()
    }

    func authCompleted() {
        performSegue(withIdentifier: Constants.logoutSegue, sender: self)
    }

    func showMessage(title: String, message: String, buttonText: String) {
        let message = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let closeDialogAction = UIAlertAction(title: buttonText, style: .default)
        message.addAction(closeDialogAction)

        self.present(message, animated: true)
    }

}

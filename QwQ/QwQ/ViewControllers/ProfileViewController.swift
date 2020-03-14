//
//  ProfileViewController.swift
//  QwQ
//
//  Created by Tan Su Yee on 13/3/20.
//

import UIKit

class ProfileViewController: UIViewController, ProfileDelegate {

    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var contactLabel: UILabel!
    @IBOutlet private var emailLabel: UILabel!
    @IBOutlet private var profileImageView: UIImageView!
    
    let profileStorage: ProfileStorage

    init() {
        profileStorage = FBProfileStorage()
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        profileStorage = FBProfileStorage()
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileStorage.setDelegate(delegate: self)
        
        profileImageView.layer.borderWidth = Constants.profileBorderWidth
        profileImageView.layer.masksToBounds = false
        profileImageView.layer.borderColor = Constants.profileBorderColor
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.clipsToBounds = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        profileStorage.getCustomerInfo()
    }

    func getCustomerInfoComplete(customer: Customer) {
        self.nameLabel.text = customer.name
        self.contactLabel.text = customer.contact
        self.emailLabel.text = customer.email
    }

    func updateComplete() {
        return
    }

    func showMessage(title: String, message: String, buttonText: String) {
        let message = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let closeDialogAction = UIAlertAction(title: buttonText, style: .default)
        message.addAction(closeDialogAction)

        self.present(message, animated: true)
    }

}

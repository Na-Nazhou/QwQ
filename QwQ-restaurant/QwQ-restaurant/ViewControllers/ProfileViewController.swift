//
//  ProfileViewController.swift
//  QwQ-restaurant
//
//  Created by Tan Su Yee on 14/3/20.
//  Copyright © 2020 Appfish. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, AuthDelegate, ProfileDelegate {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var contactLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var menuLabel: UILabel!

    @IBOutlet weak var profileImageView: UIImageView!

    let auth: Authenticator
    let profileStorage: ProfileStorage

    init() {
        self.auth = FBAuthenticator()
        self.profileStorage = FBProfileStorage()
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        self.auth = FBAuthenticator()
        self.profileStorage = FBProfileStorage()
        super.init(coder: coder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        auth.setDelegate(delegate: self)

        profileStorage.setDelegate(delegate: self)
        profileStorage.getRestaurantInfo()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        profileStorage.getRestaurantInfo()
    }

    @IBAction func logoutButton(_ sender: Any) {
        auth.logout()
    }

    func authCompleted() {
        performSegue(withIdentifier: Constants.logoutSegue, sender: self)
    }

    func getRestaurantInfoComplete(restaurant: Restaurant) {
        self.nameLabel.text = restaurant.name
        self.emailLabel.text = restaurant.email
        self.contactLabel.text = restaurant.contact
        self.addressLabel.text = restaurant.address
        self.menuLabel.text = restaurant.menu

        profileStorage.getRestaurantProfilePic(uid: restaurant.uid, placeholder: profileImageView)
    }

    func updateComplete() {
        fatalError("This method is not implemeneted here.")
    }

}

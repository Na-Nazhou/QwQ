//
//  ProfileViewController.swift
//  QwQ-restaurant
//
//  Created by Tan Su Yee on 14/3/20.
//  Copyright © 2020 Appfish. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, AuthDelegate, ProfileDelegate {

    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var emailLabel: UILabel!
    @IBOutlet private var contactLabel: UILabel!
    @IBOutlet private var addressLabel: UILabel!
    @IBOutlet private var menuLabel: UILabel!

    @IBOutlet private var profileImageView: UIImageView!

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

    @IBAction private func logoutButton(_ sender: Any) {
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

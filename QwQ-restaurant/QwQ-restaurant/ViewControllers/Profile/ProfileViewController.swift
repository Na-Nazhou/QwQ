//
//  ProfileViewController.swift
//  QwQ-restaurant
//
//  Created by Tan Su Yee on 14/3/20.
//  Copyright © 2020 Appfish. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    // MARK: View properties
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var emailLabel: UILabel!
    @IBOutlet private var contactLabel: UILabel!
    @IBOutlet private var addressLabel: UILabel!
    @IBOutlet private var menuLabel: UILabel!
    @IBOutlet private var groupSizeLabel: UILabel!
    @IBOutlet private var queueTimingLabel: UILabel!
    @IBOutlet private var advanceBookingLimitLabel: UILabel!
    @IBOutlet private var profileImageView: UIImageView!

    var spinner: UIView?

    typealias Profile = FIRRestaurantStorage
    typealias Auth = FIRAuthenticator

    override func viewWillAppear(_ animated: Bool) {
        spinner = showSpinner(onView: view)
        Profile.getRestaurantInfo(completion: getRestaurantInfoComplete(restaurant:),
                                  errorHandler: handleError(error:))
        super.viewWillAppear(animated)
    }

    @IBAction private func logoutButton(_ sender: Any) {
        Auth.logout(completion: logoutComplete, errorHandler: handleError(error:))
    }

    private func getRestaurantInfoComplete(restaurant: Restaurant) {
        removeSpinner(spinner)
        self.nameLabel.text = restaurant.name
        self.emailLabel.text = restaurant.email
        self.contactLabel.text = restaurant.contact
        self.addressLabel.text = restaurant.address
        self.menuLabel.text = restaurant.menu

        Profile.getRestaurantProfilePic(uid: restaurant.uid, placeholder: profileImageView)
    }

    private func logoutComplete() {
        RestaurantPostLoginSetupManager.tearDown()
        performSegue(withIdentifier: Constants.logoutSegue, sender: self)
    }

    private func handleError(error: Error) {
        showMessage(title: Constants.errorTitle, message: error.localizedDescription, buttonText: Constants.okayTitle)
        removeSpinner(spinner)
    }

}

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

    private var spinner: UIView?

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

        nameLabel.text = restaurant.name
        emailLabel.text = restaurant.email
        contactLabel.text = restaurant.contact
        addressLabel.text = restaurant.address
        menuLabel.text = restaurant.menu
        groupSizeLabel.text = "\(restaurant.minGroupSize) to \(restaurant.maxGroupSize) pax"
        advanceBookingLimitLabel.text = "\(restaurant.advanceBookingLimit) hours"
        queueTimingLabel.text = restaurant.operatingHours

        // TODO: Queue Status Label
        //        if restaurant.isQueueOpen, let openTime = restaurant.queueOpenTime {
        //            queueTimingLabel.text = "Opened at \(openTime.getFormattedTime())"
        //        } else {
        //            if let closeTime = restaurant.queueCloseTime {
        //                queueTimingLabel.text = "Closed at \(closeTime.getFormattedTime())"
        //            } else {
        //                queueTimingLabel.text = "Closed"
        //            }
        //        }

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

//
//  RestaurantViewController.swift
//  QwQ
//
//  Created by Tan Su Yee on 13/3/20.
//

/**
`RestaurantViewController` displays restaurant details such as location, name, contact, menu.
 
 It must conform to `RestaurantDelegate` to handle actions after restaurant is updated.
*/

import UIKit
import os

class RestaurantViewController: UIViewController {

    // MARK: View properties
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var menuLabel: UILabel!
    @IBOutlet private var locationLabel: UILabel!
    @IBOutlet private var contactLabel: UILabel!
    @IBOutlet private var emailLabel: UILabel!
    @IBOutlet private var queueButton: UIButton!
    @IBOutlet private var bookButton: UIButton!
    @IBOutlet private var groupSizeLabel: UILabel!
    @IBOutlet private var queueTimingsLabel: UILabel!
    @IBOutlet private var profileImageView: ProfileImageView!
    @IBOutlet private var bannerImageView: UIImageView!
    
    // MARK: Logic properties
    var bookingLogic: CustomerBookingLogic!
    var queueLogic: CustomerQueueLogic!
    var restaurantLogic: RestaurantLogic!

    // MARK: Model properties
    private var restaurant: Restaurant? {
        restaurantLogic.currentRestaurant
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViews()

        restaurantLogic.restaurantDelegate = self
    }

    @IBAction private func handleBack(_ sender: Any) {
        handleBack()
    }
    
    /// Segue to edit queue record view controller if restaurant is available for queueing
    @IBAction private func handleQueueTap(_ sender: Any) {
        guard let restaurant = restaurant,
            checkRestaurantQueue(for: restaurant) else {
            return
        }

        performSegue(withIdentifier: Constants.editQueueSelectedSegue, sender: self)
    }
    
    /// Segue to edit book record view controller
    @IBAction private func handleBookTap(_ sender: Any) {
        performSegue(withIdentifier: Constants.editBookSelectedSegue, sender: self)
    }

    @discardableResult
    private func checkRestaurantQueue(for restaurant: Restaurant) -> Bool {
        guard !queueLogic.canQueue(for: restaurant) else {
            return true
        }
        var format = Constants.alreadyQueuedRestaurantMessage
        if !restaurant.isQueueOpen {
            format = Constants.restaurantUnavailableMessage
        }

        showMessage(title: Constants.errorTitle,
                    message: String(format: format, restaurant.name),
                    buttonText: Constants.okayTitle)
        return false
    }
    
    private func setUpViews() {
        guard let restaurant = restaurant else {
            return
        }

        nameLabel.text = restaurant.name
        menuLabel.text = restaurant.menu
        locationLabel.text = restaurant.address
        contactLabel.text = restaurant.contact
        emailLabel.text = restaurant.email
        groupSizeLabel.text = "\(restaurant.minGroupSize) to \(restaurant.maxGroupSize) pax"
        queueTimingsLabel.text = restaurant.operatingHours

        // TODO: advance booking limit label
        // TODO: Queue Status Label
//        if restaurant.isQueueOpen, let openTime = restaurant.queueOpenTime {
//            queueTimingsLabel.text = "Opened at \(openTime.getFormattedTime())"
//        } else {
//            if let closeTime = restaurant.queueCloseTime {
//                queueTimingsLabel.text = "Closed at \(closeTime.getFormattedTime())"
//            } else {
//                queueTimingsLabel.text = "Closed"
//            }
//        }

        FIRProfileStorage.getCustomerProfilePic(uid: restaurant.uid, placeholder: profileImageView)

        if queueLogic.canQueue(for: restaurant) {
            queueButton.alpha = Constants.canQueueButtonAlpha
        } else {
            queueButton.alpha = Constants.cannotQueueButtonAlpha
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let restaurant = restaurant else {
            return
        }
        if segue.identifier == Constants.editQueueSelectedSegue {
            guard let editQVC = segue.destination as? EditQueueViewController else {
                assert(false,
                       "Destination should be editRecordVC.")
                return
            }

            restaurantLogic.currentRestaurants = [restaurant]

            editQVC.queueLogic = queueLogic
            editQVC.restaurantLogic = restaurantLogic
        } else if segue.identifier == Constants.editBookSelectedSegue {
            guard let editBVC = segue.destination as? EditBookingViewController else {
                assert(false,
                       "Destination should be editRecordVC and restaurant should not be nil.")
                return
            }

            restaurantLogic.currentRestaurants = [restaurant]

            editBVC.restaurantLogic = restaurantLogic
            editBVC.bookingLogic = bookingLogic
            return
        } else {
            os_log("Segue not found.", log: Log.segueError, type: .error)
        }
    }
}

extension RestaurantViewController: RestaurantDelegate {
    func didUpdateRestaurant() {
        setUpViews()
    }
}

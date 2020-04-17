//
//  RestaurantViewController.swift
//  QwQ
//
//  Created by Tan Su Yee on 13/3/20.
//

import UIKit

class RestaurantViewController: UIViewController, RestaurantDelegate {

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
    var restaurant: Restaurant? {
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
    
    @IBAction private func handleQueueTap(_ sender: Any) {
        guard let restaurant = restaurant,
            checkRestaurantQueue(for: restaurant) else {
            return
        }

        performSegue(withIdentifier: Constants.editQueueSelectedSegue, sender: self)
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

    @IBAction private func handleBookTap(_ sender: Any) {
        performSegue(withIdentifier: Constants.editBookSelectedSegue, sender: self)
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
            queueButton.alpha = 1
        } else {
            queueButton.alpha = 0.5
        }
    }

    func didUpdateRestaurant() {
        setUpViews()
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
        }
        if segue.identifier == Constants.editBookSelectedSegue {
            guard let editBVC = segue.destination as? EditBookingViewController else {
                assert(false,
                       "Destination should be editRecordVC and restaurant should not be nil.")
                return
            }

            restaurantLogic.currentRestaurants = [restaurant]

            editBVC.restaurantLogic = restaurantLogic
            editBVC.bookingLogic = bookingLogic
            return
        }
    }
}

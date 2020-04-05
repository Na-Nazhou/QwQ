//
//  RestaurantViewController.swift
//  QwQ
//
//  Created by Tan Su Yee on 13/3/20.
//

import UIKit

class RestaurantViewController: UIViewController, RestaurantDelegate {

    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var menuLabel: UILabel!
    @IBOutlet private var locationLabel: UILabel!
    @IBOutlet private var contactLabel: UILabel!
    @IBOutlet private var emailLabel: UILabel!
    @IBOutlet private var queueButton: UIButton!
    @IBOutlet private var bookButton: UIButton!

    var bookingLogicManager: CustomerBookingLogicManager!
    var queueLogicManager: CustomerQueueLogicManager!
    var restaurantLogicManager: RestaurantLogicManager!
    var restaurant: Restaurant? {
        restaurantLogicManager.currentRestaurant
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViews()

        restaurantLogicManager.restaurantDelegate = self
    }
    
    @IBAction private func handleQueueTap(_ sender: Any) {
        guard let restaurant = restaurant else {
            return
        }
        // Cannot queue if the restaurant is currently not open
        if !restaurant.isQueueOpen {
            showMessage(title: Constants.errorTitle,
                        message: Constants.restaurantUnavailableMessage,
                        buttonText: Constants.okayTitle)
            return
        }

        if !queueLogicManager.canQueue(for: restaurant) {
            showMessage(title: Constants.errorTitle,
                        message: Constants.alreadyQueuedRestaurantMessage,
                        buttonText: Constants.okayTitle)
            return
        }

        performSegue(withIdentifier: Constants.editQueueSelectedSegue, sender: self)
    }

    @IBAction private func handleBookTap(_ sender: Any) {
        performSegue(withIdentifier: Constants.editBookSelectedSegue, sender: self)
    }
    
    @IBAction private func handleBack(_ sender: Any) {
        handleBack()
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

        if restaurant.isQueueOpen {
            queueButton.alpha = 1
        } else {
            queueButton.alpha = 0.5
        }
    }

    func didUpdateRestaurant() {
        setUpViews()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.editQueueSelectedSegue {
            guard let editQVC = segue.destination as? EditQueueViewController else {
                assert(false,
                       "Destination should be editRecordVC.")
                return
            }
            editQVC.queueLogicManager = queueLogicManager
            editQVC.restaurantLogicManager = restaurantLogicManager
        }
        if segue.identifier == Constants.editBookSelectedSegue {
            guard let editBVC = segue.destination as? EditBookingViewController else {
                assert(false,
                       "Destination should be editRecordVC and restaurant should not be nil.")
                return
            }
            editBVC.restaurantLogicManager = restaurantLogicManager
            editBVC.bookingLogicManager = bookingLogicManager
            return
        }
    }
}

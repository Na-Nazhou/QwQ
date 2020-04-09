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
        guard let restaurant = restaurant,
            checkRestaurantQueue(for: restaurant) else {
            return
        }

        performSegue(withIdentifier: Constants.editQueueSelectedSegue, sender: self)
    }

    @discardableResult
    private func checkRestaurantQueue(for restaurant: Restaurant) -> Bool {
        guard !queueLogicManager.canQueue(for: restaurant) else {
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

        if queueLogicManager.canQueue(for: restaurant) {
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

            restaurantLogicManager.currentRestaurants = [restaurant]

            editQVC.queueLogicManager = queueLogicManager
            editQVC.restaurantLogicManager = restaurantLogicManager
        }
        if segue.identifier == Constants.editBookSelectedSegue {
            guard let editBVC = segue.destination as? EditBookingViewController else {
                assert(false,
                       "Destination should be editRecordVC and restaurant should not be nil.")
                return
            }

            restaurantLogicManager.currentRestaurants = [restaurant]

            editBVC.restaurantLogicManager = restaurantLogicManager
            editBVC.bookingLogicManager = bookingLogicManager
            return
        }
    }
}

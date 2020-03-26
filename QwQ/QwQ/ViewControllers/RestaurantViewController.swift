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

    var restaurant: Restaurant? {
        RestaurantLogicManager.shared().currentRestaurant
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViews()

        RestaurantLogicManager.shared().restaurantDelegate = self
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

        if CustomerQueueLogicManager.shared().canQueue(for: restaurant) {
            performSegue(withIdentifier: Constants.editQueueSelectedSegue, sender: self)
        } else {
            showMessage(title: Constants.errorTitle,
                        message: Constants.multipleQueueRecordsMessage,
                        buttonText: Constants.okayTitle)
        }
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
    }

    func restaurantDidSetQueueStatus(toIsOpen isOpen: Bool) {
        //TODO
    }
}

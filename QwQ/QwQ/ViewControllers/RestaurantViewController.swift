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
        if !restaurant.isOpen {
            showMessage(title: "Error", message: "This restaurant is currently not open!",
                        buttonText: Constants.okayTitle, buttonAction: nil)
            return
        }

        if CustomerQueueLogicManager.shared().canQueue(for: restaurant) {
            performSegue(withIdentifier: Constants.editQueueSelectedSegue, sender: self)
        } else {
            showMessage(title: "Error", message: "You have an existing queue record",
                        buttonText: Constants.okayTitle, buttonAction: nil)
        }
    }

    @IBAction private func handleBookTap(_ sender: Any) {
        performSegue(withIdentifier: Constants.editBookSelectedSegue, sender: self)
    }
    
    @IBAction private func handleBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    private func setUpViews() {
        guard let restaurant = restaurant else {
            return
        }

        nameLabel.text = restaurant.name
        menuLabel.text = restaurant.menu
        locationLabel.text = restaurant.address
    }

    func restaurantDidSetQueueStatus(toIsOpen isOpen: Bool) {
        //TODO
    }

}

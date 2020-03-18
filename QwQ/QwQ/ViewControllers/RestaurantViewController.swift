//
//  RestaurantViewController.swift
//  QwQ
//
//  Created by Tan Su Yee on 13/3/20.
//

import UIKit

class RestaurantViewController: UIViewController, RestaurantDelegate {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var menuLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!

    var restaurant: Restaurant? {
        RestaurantLogicManager.shared().currentRestaurant
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViews()

        RestaurantLogicManager.shared().restaurantDelegate = self
    }
    
    @IBAction private func handleQueueTap(_ sender: Any) {
        performSegue(withIdentifier: Constants.queueSelectedSegue, sender: self)
    }

    @IBAction private func handleBookTap(_ sender: Any) {
        performSegue(withIdentifier: Constants.bookSelectedSegue, sender: self)
    }
    
    @IBAction private func handleBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    private func setUpViews() {
        nameLabel.text = restaurant?.name
        menuLabel.text = restaurant?.menu
        locationLabel.text = restaurant?.address
    }

    func restaurantDidSetQueueStatus(toIsOpen isOpen: Bool) {
        //
    }
}

//
//  RestaurantCell.swift
//  QwQ
//
//  Created by Tan Su Yee on 15/3/20.
//

import UIKit

class RestaurantCell: UICollectionViewCell {
    var queueAction: (() -> Bool)?
    var canQueue: Bool = false
    
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var locationLabel: UILabel!
    @IBOutlet private var queueButton: UIButton!
    @IBOutlet private var profileImageView: UIImageView!

    typealias RestaurantStorage = FIRRestaurantInfoStorage
    
    @IBAction private func handleQueueTap(sender: Any?) {
        if queueAction?() ?? false {
            canQueue = true
        } else {
            canQueue = false
        }
        setUpQueueButton()
    }

    func setUpView(restaurant: Restaurant) {
        nameLabel.text = restaurant.name
        locationLabel.text = restaurant.address

        RestaurantStorage.getRestaurantProfilePic(uid: restaurant.uid, imageView: profileImageView)
        setUpQueueButton()
    }

    private func setUpQueueButton() {
        if canQueue {
            queueButton.alpha = 1
        } else {
            queueButton.alpha = 0.5
        }
    }
}

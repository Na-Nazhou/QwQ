//
//  RestaurantCell.swift
//  QwQ
//
//  Created by Tan Su Yee on 15/3/20.
//

import UIKit

class RestaurantCell: UICollectionViewCell {
    var queueAction: (() -> Void)?
    var canQueue: Bool = false
    
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var locationLabel: UILabel!
    @IBOutlet private var queueButton: UIButton!

    @IBAction private func handleQueueTap(sender: Any?) {
        queueAction?()
    }

    func setUpView(restaurant: Restaurant) {
        nameLabel.text = restaurant.name
        locationLabel.text = restaurant.address

        if canQueue {
            queueButton.alpha = 1
        } else {
            queueButton.alpha = 0.5
        }
    }
}

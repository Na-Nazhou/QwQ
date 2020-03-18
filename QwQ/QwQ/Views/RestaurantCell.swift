//
//  RestaurantCell.swift
//  QwQ
//
//  Created by Tan Su Yee on 15/3/20.
//

import UIKit

class RestaurantCell: UICollectionViewCell {
    var queueAction: (() -> Void)?
    
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var locationLabel: UILabel!

    @IBAction private func handleQueueTap(sender: Any?) {
        queueAction?()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    // MARK: Codable

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func setUpView(restaurant: Restaurant) {
        nameLabel.text = restaurant.name
        locationLabel.text = restaurant.address
    }
}

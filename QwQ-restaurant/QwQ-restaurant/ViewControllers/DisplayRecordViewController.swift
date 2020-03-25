//
//  DisplayRecordViewController.swift
//  QwQ
//
//  Created by Daniel Wong on 25/3/20.
//

import UIKit

protocol DisplayRecordViewController: UIViewController {
    var nameLabel: UILabel! { get set }
    var contactLabel: UILabel! { get set }
    var groupSizeLabel: UILabel! { get set }
    var babyChairQuantityLabel: UILabel! { get set }
    var profileImageView: UIImageView! { get set }
    var wheelchairFriendlySwitch: UISwitch! { get set }

    var record: Record? { get set }
}

extension DisplayRecordViewController {
    func setUpRecordView() {
        if let record = record {
            nameLabel.text = record.restaurant.name
            contactLabel.text = record.restaurant.contact
            groupSizeLabel.text = String(record.groupSize)
            babyChairQuantityLabel.text = String(record.babyChairQuantity)
            wheelchairFriendlySwitch.isOn = record.wheelchairFriendly
        }
    }

}
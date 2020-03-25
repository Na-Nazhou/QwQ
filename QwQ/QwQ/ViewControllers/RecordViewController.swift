//
//  DisplayRecordViewController.swift
//  QwQ
//
//  Created by Daniel Wong on 25/3/20.
//

import UIKit

protocol RecordViewController: UIViewController {
    var nameLabel: UILabel! { get set }
    var contactLabel: UILabel! { get set }
    var locationLabel: UILabel! { get set }
    var groupSizeLabel: UILabel! { get set }
    var babyChairQuantityLabel: UILabel! { get set }
    var profileImageView: UIImageView! { get set }
    var wheelchairFriendlySwitch: UISwitch! { get set }

    var record: Record? { get set }
}

extension RecordViewController {
    func setUpRecordView() {
        if let record = record {
            nameLabel.text = record.restaurant.name
            contactLabel.text = record.restaurant.contact
            locationLabel.text = record.restaurant.address
            groupSizeLabel.text = String(record.groupSize)
            babyChairQuantityLabel.text = String(record.babyChairQuantity)
            wheelchairFriendlySwitch.isOn = record.wheelchairFriendly
            FBProfileStorage.getCustomerProfilePic(uid: record.restaurant.uid, placeholder: profileImageView)
        }
    }

}

//
//  RecordViewController.swift
//  QwQ
//
//  Created by Daniel Wong on 24/3/20.
//

import UIKit

protocol RecordViewController: UIViewController {
    var nameTextField: UITextField! { get set }
    var contactTextField: UITextField! { get set }
    var groupSizeTextField: UITextField! { get set }
    var babyChairQuantityTextField: UITextField! { get set }
    var wheelchairFriendlySwitch: UISwitch! { get set }
    var restaurantNameLabel: UILabel! { get set }

    var record: Record? { get set }

}

extension RecordViewController {
    func setUpRecordView() {
        if let record = record {
            restaurantNameLabel.text = record.restaurant.name
            nameTextField.text = record.customer.name
            contactTextField.text = record.customer.contact
            groupSizeTextField.text = String(record.groupSize)
            babyChairQuantityTextField.text = String(record.babyChairQuantity)
            wheelchairFriendlySwitch.isOn = record.wheelchairFriendly
        }
    }
}

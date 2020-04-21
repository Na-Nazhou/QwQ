//
//  DisplayRecordViewController.swift
//  QwQ
//
//  Created by Daniel Wong on 25/3/20.
//

import UIKit

class RecordViewController: UIViewController {

    // MARK: View properties
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var contactLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var groupSizeLabel: UILabel!
    @IBOutlet var babyChairQuantityLabel: UILabel!
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var wheelchairFriendlySwitch: UISwitch!

    // MARK: Model properties
    var record: Record?

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpViews()
    }

    @IBAction func handleBack(_ sender: Any) {
        handleBack()
    }

    func setUpViews() {
        guard let record = record else {
            return
        }

        nameLabel.text = record.restaurant.name
        contactLabel.text = record.restaurant.contact
        locationLabel.text = record.restaurant.address
        groupSizeLabel.text = String(record.groupSize)
        babyChairQuantityLabel.text = String(record.babyChairQuantity)
        wheelchairFriendlySwitch.isOn = record.wheelchairFriendly
        FIRProfileStorage.getCustomerProfilePic(uid: record.restaurant.uid, placeholder: profileImageView)
    }
}

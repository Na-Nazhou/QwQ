//
//  BookRecordViewController.swift
//  QwQ
//
//  Created by Tan Su Yee on 18/3/20.
//

import UIKit

class BookRecordViewController: UIViewController {
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var contactLabel: UILabel!
    @IBOutlet private var groupSizeLabel: UILabel!
    @IBOutlet private var locationLabel: UILabel!
    @IBOutlet private var babyChairQuantityLabel: UILabel!
    @IBOutlet private var profileImageView: UIImageView!
    @IBOutlet private var wheelchairFriendlySwitch: UISwitch!
    @IBOutlet private var datePicker: UIDatePicker!

    var bookRecord: BookRecord?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViews()
    }
    
    @IBAction private func handleBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    private func setUpViews() {
        guard let bookRecord = bookRecord else {
            return
        }

        nameLabel.text = bookRecord.restaurant.name
        contactLabel.text = bookRecord.restaurant.contact
        locationLabel.text = bookRecord.restaurant.address
        groupSizeLabel.text = String(bookRecord.groupSize)
        babyChairQuantityLabel.text = String(bookRecord.babyChairQuantity)
        wheelchairFriendlySwitch.isOn = bookRecord.wheelchairFriendly

        // TODO
    }
}

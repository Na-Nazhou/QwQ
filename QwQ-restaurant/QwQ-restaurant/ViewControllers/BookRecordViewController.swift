//
//  BookRecordViewController.swift
//  QwQ-restaurant
//
//  Created by Tan Su Yee on 18/3/20.
//

import UIKit

class BookRecordViewController: UIViewController {
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var contactLabel: UILabel!
    @IBOutlet private var groupSizeLabel: UILabel!
    @IBOutlet private var babyChairQuantityLabel: UILabel!
    @IBOutlet private var profileImageView: UIImageView!
    @IBOutlet private var wheelchairFriendlySwitch: UISwitch!
    
    var bookRecord: BookRecord?
    
    @IBAction private func handleAdmit(_ sender: Any) {
        showMessage(title: Constants.admitCustomerTitle,
                    message: Constants.admitCustomerMessage,
                    buttonText: Constants.okayTitle)
    }
    
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
        groupSizeLabel.text = String(bookRecord.groupSize)
        babyChairQuantityLabel.text = String(bookRecord.babyChairQuantity)
        wheelchairFriendlySwitch.isOn = bookRecord.wheelchairFriendly

        // TODO
    }
}

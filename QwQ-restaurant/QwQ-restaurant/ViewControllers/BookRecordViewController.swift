//
//  BookRecordViewController.swift
//  QwQ-restaurant
//
//  Created by Tan Su Yee on 18/3/20.
//

import UIKit

class BookRecordViewController: UIViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var contactLabel: UILabel!
    @IBOutlet weak var groupSizeLabel: UILabel!
    @IBOutlet weak var babyChairQuantityLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var wheelchairFriendlySwitch: UISwitch!
    
    var bookRecord: BookRecord?
    
    @IBAction func handleAdmit(_ sender: Any) {
        showMessage(title: Constants.admitCustomerTitle,
                    message: Constants.admitCustomerMessage,
                    buttonText: Constants.okayTitle)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViews()
    }
    
    @IBAction func handleBack(_ sender: Any) {
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

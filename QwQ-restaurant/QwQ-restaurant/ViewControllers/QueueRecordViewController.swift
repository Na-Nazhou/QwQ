//
//  QueueViewController.swift
//  QwQ-restaurant
//
//  Created by Tan Su Yee on 15/3/20.
//

import UIKit

class QueueRecordViewController: UIViewController {
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var contactLabel: UILabel!
    @IBOutlet private var groupSizeLabel: UILabel!
    @IBOutlet private var babyChairQuantityLabel: UILabel!
    @IBOutlet private var profileImageView: UIImageView!
    @IBOutlet private var wheelchairFriendlySwitch: UISwitch!

    typealias Profile = FBProfileStorage

    var queueRecord: QueueRecord?
    
    @IBAction private func handleAdmit(_ sender: Any) {
        showMessage(title: Constants.admitCustomerTitle,
                    message: Constants.admitCustomerMessage,
                    buttonText: Constants.okayTitle,
                    buttonAction: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViews()
    }
    
    @IBAction private func handleBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    private func setUpViews() {
        guard let queueRecord = queueRecord else {
            return
        }

        nameLabel.text = queueRecord.customer.name
        contactLabel.text = queueRecord.customer.contact
        Profile.getRestaurantProfilePic(uid: queueRecord.customer.uid, placeholder: profileImageView)

        groupSizeLabel.text = String(queueRecord.groupSize)
        babyChairQuantityLabel.text = String(queueRecord.babyChairQuantity)
        wheelchairFriendlySwitch.isOn = queueRecord.wheelchairFriendly
    }
}

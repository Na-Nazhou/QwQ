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

        nameLabel.text = queueRecord.restaurant.name
        contactLabel.text = queueRecord.restaurant.contact
        groupSizeLabel.text = String(queueRecord.groupSize)
        babyChairQuantityLabel.text = String(queueRecord.babyChairQuantity)
        wheelchairFriendlySwitch.isOn = queueRecord.wheelchairFriendly
    }
}

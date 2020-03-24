//
//  QueueRecordViewController.swift
//  QwQ
//
//  Created by Tan Su Yee on 18/3/20.
//

import UIKit

class QueueRecordViewController: UIViewController {
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var contactLabel: UILabel!
    @IBOutlet private var locationLabel: UILabel!
    @IBOutlet private var groupSizeLabel: UILabel!
    @IBOutlet private var babyChairQuantityLabel: UILabel!
    @IBOutlet private var profileImageView: UIImageView!
    @IBOutlet private var wheelchairFriendlySwitch: UISwitch!

    typealias Profile = FBProfileStorage
    
    var queueRecord: QueueRecord?

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
        locationLabel.text = queueRecord.restaurant.address
        Profile.getCustomerProfilePic(uid: queueRecord.restaurant.uid, placeholder: profileImageView)

        groupSizeLabel.text = String(queueRecord.groupSize)
        babyChairQuantityLabel.text = String(queueRecord.babyChairQuantity)
        wheelchairFriendlySwitch.isOn = queueRecord.wheelchairFriendly
    }
    
}

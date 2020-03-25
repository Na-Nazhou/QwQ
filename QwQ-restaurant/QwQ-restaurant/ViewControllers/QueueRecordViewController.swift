//
//  QueueViewController.swift
//  QwQ-restaurant
//
//  Created by Tan Su Yee on 15/3/20.
//

import UIKit

class QueueRecordViewController: UIViewController, DisplayRecordViewController {
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var contactLabel: UILabel!
    @IBOutlet var groupSizeLabel: UILabel!
    @IBOutlet var babyChairQuantityLabel: UILabel!
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var wheelchairFriendlySwitch: UISwitch!
    
    var record: Record?

    typealias Profile = FBProfileStorage
    
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
        handleBack()
    }

    private func setUpViews() {
        guard let queueRecord = record as? QueueRecord else {
            return
        }
        setUpRecordView()

        Profile.getRestaurantProfilePic(uid: queueRecord.customer.uid, placeholder: profileImageView)
    }
}

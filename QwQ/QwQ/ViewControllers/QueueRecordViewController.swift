//
//  QueueRecordViewController.swift
//  QwQ
//
//  Created by Tan Su Yee on 18/3/20.
//

import UIKit

class QueueRecordViewController: UIViewController, DisplayRecordViewController {
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var contactLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var groupSizeLabel: UILabel!
    @IBOutlet var babyChairQuantityLabel: UILabel!
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var wheelchairFriendlySwitch: UISwitch!

    typealias Profile = FBProfileStorage

    var record: Record?

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

        Profile.getCustomerProfilePic(uid: queueRecord.restaurant.uid, placeholder: profileImageView)
    }
}

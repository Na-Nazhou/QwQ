//
//  QueueRecordViewController.swift
//  QwQ
//
//  Created by Tan Su Yee on 18/3/20.
//

import UIKit

class QueueRecordViewController: UIViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var contactLabel: UILabel!
    @IBOutlet weak var groupSizeLabel: UILabel!
    @IBOutlet weak var babyChairQuantityLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var wheelchairFriendlySwitch: UISwitch!
    
    var queueRecord: QueueRecord?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViews()
    }
    
    @IBAction func handleBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    private func setUpViews() {
        nameLabel.text = queueRecord?.customer.name
        contactLabel.text = queueRecord?.customer.contact
        groupSizeLabel.text = String(queueRecord?.groupSize ?? 0)
        babyChairQuantityLabel.text = String(queueRecord?.wheelchairFriendly ?? false)
        wheelchairFriendlySwitch.isOn = queueRecord?.wheelchairFriendly ?? false
    }
    
}

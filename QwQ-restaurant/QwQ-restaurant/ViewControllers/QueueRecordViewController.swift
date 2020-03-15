//
//  QueueViewController.swift
//  QwQ-restaurant
//
//  Created by Tan Su Yee on 15/3/20.
//

import UIKit

class QueueRecordViewController: UIViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var contactLabel: UILabel!
    @IBOutlet weak var groupSizeLabel: UILabel!
    @IBOutlet weak var babyChairQuantityLabel: UILabel!
    @IBOutlet weak var wheelchairFriendlySwitch: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    
    var queueRecord: QueueRecord?
    
    @IBAction func handleSubmit(_ sender: Any) {
    }
    
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
        babyChairQuantityLabel.text = String(queueRecord?.babyChairQuantity ?? 0)
//        wheelchairFriendlySwitch. = String(queueRecord?.wheelchairFriendly)
    }
}

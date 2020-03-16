//
//  EditQueueViewController.swift
//  QwQ
//
//  Created by Tan Su Yee on 15/3/20.
//

import UIKit

class EditQueueViewController: UIViewController {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var contactTextField: UITextField!
    @IBOutlet weak var groupSizeTextField: UITextField!
    @IBOutlet weak var babyChairQuantityTextField: UITextField!
    @IBOutlet weak var wheelChairFriendlySwitch: UISwitch!

    var queueRecord: QueueRecord? {
        CustomerQueueLogicManager.shared().currentQueueRecord
    }
    
    @IBAction func handleSubmit(_ sender: Any) {
        guard let restaurant = RestaurantLogicManager.shared().currentRestaurant,
            let groupSizeText = groupSizeTextField.text,
            let babyChairQueantityText = babyChairQuantityTextField.text,
            let groupSize = Int(groupSizeText),
            let babyChairQuantity = Int(babyChairQueantityText) else {
            return
        }

        // Edit existing queue record
        if queueRecord != nil {
            CustomerQueueLogicManager.shared()
            .editQueueRecord(with: groupSize,
                             babyChairQuantity: babyChairQuantity,
                             wheelchairFriendly: wheelChairFriendlySwitch.isOn)
        }

        // Create a new queue record
        CustomerQueueLogicManager.shared()
            .enqueue(to: restaurant,
                     with: groupSize,
                     babyChairQuantity: babyChairQuantity,
                     wheelchairFriendly: wheelChairFriendlySwitch.isOn)
    }
    
    @IBAction func handleBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if let queueRecord = queueRecord {
            nameTextField.text = queueRecord.customer.name
            contactTextField.text = queueRecord.customer.contact
            groupSizeTextField.text = String(queueRecord.groupSize)
            babyChairQuantityTextField.text = String(queueRecord.babyChairQuantity)
            wheelChairFriendlySwitch.isOn = queueRecord.wheelchairFriendly
        } else {
            nameTextField.text = CustomerQueueLogicManager.shared().customer.name
            contactTextField.text = CustomerQueueLogicManager.shared().customer.contact
        }
    }
}

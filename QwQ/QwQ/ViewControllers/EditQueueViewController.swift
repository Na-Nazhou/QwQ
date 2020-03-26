//
//  EditQueueViewController.swift
//  QwQ
//
//  Created by Tan Su Yee on 15/3/20.
//

import UIKit

class EditQueueViewController: EditRecordViewController, RecordDelegate {

    @IBAction override func handleSubmit(_ sender: Any) {
        guard let groupSizeText = groupSizeTextField.text,
            let babyChairQueantityText = babyChairQuantityTextField.text,
            let groupSize = Int(groupSizeText.trimmingCharacters(in: .newlines)),
            let babyChairQuantity = Int(babyChairQueantityText.trimmingCharacters(in: .newlines)) else {
                showMessage(title: Constants.errorTitle,
                            message: "Missing fields",
                            buttonText: Constants.okayTitle,
                            buttonAction: nil)
                return
        }

        spinner = showSpinner(onView: view)

        // Edit existing queue record
        if let queueRecord = record as? QueueRecord {
            CustomerQueueLogicManager.shared()
                .editQueueRecord(oldRecord: queueRecord,
                                 with: groupSize,
                                 babyChairQuantity: babyChairQuantity,
                                 wheelchairFriendly: wheelchairFriendlySwitch.isOn)
            return
        }

         // Create a new queue record
        guard let restaurant = RestaurantLogicManager.shared().currentRestaurant else {
            return
        }
        CustomerQueueLogicManager.shared()
            .enqueue(to: restaurant,
                     with: groupSize,
                     babyChairQuantity: babyChairQuantity,
                     wheelchairFriendly: wheelchairFriendlySwitch.isOn)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        CustomerQueueLogicManager.shared().queueDelegate = self
    }
}

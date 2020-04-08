//
//  EditQueueViewController.swift
//  QwQ
//
//  Created by Tan Su Yee on 15/3/20.
//

import UIKit

class EditQueueViewController: EditRecordViewController, QueueDelegate {

    var queueLogicManager: CustomerQueueLogicManager!

    @IBAction override func handleSubmit(_ sender: Any) {
        guard super.checkRecordDetails() else {
            return
        }

        guard let groupSize = groupSize,
            let babyChairQuantity = babyChairQuantity  else {
                return
        }

        // Edit existing queue record
        if let queueRecord = record as? QueueRecord {
            queueLogicManager
                .editQueueRecord(oldRecord: queueRecord,
                                 with: groupSize,
                                 babyChairQuantity: babyChairQuantity,
                                 wheelchairFriendly: wheelchairFriendlySwitch.isOn)
            spinner = showSpinner(onView: view)
            return
        }

         // Create a new queue record
        if queueLogicManager
            .enqueue(to: restaurants,
                     with: groupSize,
                     babyChairQuantity: babyChairQuantity,
                     wheelchairFriendly: wheelchairFriendlySwitch.isOn) {
            spinner = showSpinner(onView: view)
        } else {
            showMessage(title: Constants.errorTitle,
                        message: "",
                        buttonText: Constants.okayTitle)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        queueLogicManager.queueDelegate = self
    }

    func didFindRestaurantQueueClosed() {
        showMessage(title: Constants.errorTitle,
                    message: Constants.restaurantUnavailableMessage,
                    buttonText: Constants.okayTitle)
    }
}

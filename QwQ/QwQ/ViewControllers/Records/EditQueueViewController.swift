//
//  EditQueueViewController.swift
//  QwQ
//
//  Created by Tan Su Yee on 15/3/20.
//

/**
`EditQueueViewController` enables editing of a queue record.
 
 It must conform to `QueueDelegate` to enable error handling if restaurant queue is closed.
*/

import UIKit

class EditQueueViewController: EditRecordViewController {

    // MARK: Logic properties
    var queueLogic: CustomerQueueLogic!

    /// Update queue record with new info
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
            queueLogic
                .editQueueRecord(oldRecord: queueRecord,
                                 with: groupSize,
                                 babyChairQuantity: babyChairQuantity,
                                 wheelchairFriendly: wheelchairFriendlySwitch.isOn)
            spinner = showSpinner(onView: view)
            return
        }

         // Create a new queue record
        if queueLogic
            .enqueue(to: restaurants,
                     with: groupSize,
                     babyChairQuantity: babyChairQuantity,
                     wheelchairFriendly: wheelchairFriendlySwitch.isOn) {
            spinner = showSpinner(onView: view)
        } 
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        queueLogic.queueDelegate = self
    }
}

extension EditQueueViewController: QueueDelegate {
    func didFindRestaurantQueueClosed(for restaurant: Restaurant) {
        showMessage(title: Constants.errorTitle,
                    message: String(format: Constants.restaurantUnavailableMessage, restaurant.name),
                    buttonText: Constants.okayTitle)
    }
}

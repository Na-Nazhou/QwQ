//
//  EditQueueViewController.swift
//  QwQ
//
//  Created by Tan Su Yee on 15/3/20.
//

import UIKit

class EditQueueViewController: EditRecordViewController, RecordDelegate {

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
            CustomerQueueLogicManager.shared()
                .editQueueRecord(oldRecord: queueRecord,
                                 with: groupSize,
                                 babyChairQuantity: babyChairQuantity,
                                 wheelchairFriendly: wheelchairFriendlySwitch.isOn)
            spinner = showSpinner(onView: view)
            return
        }

         // Create a new queue record
        guard let restaurant = RestaurantLogicManager.shared().currentRestaurant else {
            return
        }

        if !restaurant.isQueueOpen {
                   showMessage(title: Constants.errorTitle,
                               message: Constants.restaurantUnavailableMessage,
                               buttonText: Constants.okayTitle)
                   return
        }
        
        CustomerQueueLogicManager.shared()
            .enqueue(to: restaurant,
                     with: groupSize,
                     babyChairQuantity: babyChairQuantity,
                     wheelchairFriendly: wheelchairFriendlySwitch.isOn)
        spinner = showSpinner(onView: view)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        CustomerQueueLogicManager.shared().queueDelegate = self
    }
}

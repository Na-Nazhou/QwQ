//
//  QueueViewController.swift
//  QwQ-restaurant
//
//  Created by Tan Su Yee on 15/3/20.
//

import UIKit

class QueueRecordViewController: RecordViewController {

    // MARK: Logic properties
    var queueLogic: RestaurantQueueLogic!

    override func setUpViews() {
        guard record as? QueueRecord != nil else {
             return
         }

        super.setUpViews()

        if !PermissionsManager.checkPermissions(Permission.acceptQueue) {
            hideActionButton()
        }
    }

    @IBAction override func handleAdmit(_ sender: Any) {
        guard let queueRecord = record as? QueueRecord else {
            return
        }
    
        spinner = showSpinner(onView: view)
        queueLogic.admitCustomer(record: queueRecord,
                                 completion: self.didUpdateRecord)
    }

    @IBAction override func handleServe(_ sender: Any) {
        guard let queueRecord = record as? QueueRecord else {
            return
        }

        spinner = showSpinner(onView: view)
        queueLogic.serveCustomer(record: queueRecord,
                                 completion: self.didUpdateRecord)

    }

    // TODO: add reject button 
    @IBAction override func handleReject(_ sender: Any) {
        guard let queueRecord = record as? QueueRecord else {
            return
        }

        spinner = showSpinner(onView: view)
        queueLogic.rejectCustomer(record: queueRecord,
                                  completion: self.didUpdateRecord)
    }
}

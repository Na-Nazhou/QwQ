//
//  QueueViewController.swift
//  QwQ-restaurant
//
//  Created by Tan Su Yee on 15/3/20.
//

import UIKit

class QueueRecordViewController: RecordViewController {

    @IBAction override func handleAdmit(_ sender: Any) {
        guard let bookRecord = record as? QueueRecord else {
            return
        }
        self.spinner = self.showSpinner(onView: self.view)
        recordLogicManager.admitCustomer(record: bookRecord,
                           completion: self.didUpdateRecord)
    }

    @IBAction override func handleServe(_ sender: Any) {
        guard let bookRecord = record as? QueueRecord else {
            return
        }
        self.spinner = self.showSpinner(onView: self.view)
        recordLogicManager.serveCustomer(record: bookRecord,
                           completion: self.didUpdateRecord)

    }

    // TODO
    @IBAction override func handleReject(_ sender: Any) {
        guard let queueRecord = record as? QueueRecord else {
            return
        }
        self.spinner = self.showSpinner(onView: self.view)
        recordLogicManager.rejectCustomer(record: queueRecord,
                            completion: self.didUpdateRecord)
    }
}

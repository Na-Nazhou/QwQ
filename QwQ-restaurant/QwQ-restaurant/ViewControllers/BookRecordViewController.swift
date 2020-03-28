//
//  BookRecordViewController.swift
//  QwQ-restaurant
//
//  Created by Tan Su Yee on 18/3/20.
//

import UIKit

class BookRecordViewController: RecordViewController {

    @IBOutlet var datePicker: UIDatePicker!
    
    override func setUpViews() {
        super.setUpViews()
        guard let bookRecord = record as? BookRecord else {
            return
        }

        datePicker.date = bookRecord.time
    }

    @IBAction override func handleAdmit(_ sender: Any) {
        guard let bookRecord = record as? BookRecord else {
            return
        }
        self.spinner = self.showSpinner(onView: self.view)
        RestaurantRecordLogicManager.shared()
            .admitCustomer(record: bookRecord,
                           completion: self.didUpdateRecord)
    }

    @IBAction override func handleServe(_ sender: Any) {
        guard let bookRecord = record as? BookRecord else {
            return
        }
        self.spinner = self.showSpinner(onView: self.view)
        RestaurantRecordLogicManager.shared()
            .serveCustomer(record: bookRecord,
                           completion: self.didUpdateRecord)

    }

    // TODO
    @IBAction override func handleReject(_ sender: Any) {
        guard let queueRecord = record as? BookRecord else {
            return
        }
        self.spinner = self.showSpinner(onView: self.view)
        RestaurantRecordLogicManager.shared()
            .rejectCustomer(record: queueRecord,
                            completion: self.didUpdateRecord)
    }
}

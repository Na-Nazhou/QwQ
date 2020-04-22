//
//  BookRecordViewController.swift
//  QwQ-restaurant
//
//  Created by Tan Su Yee on 18/3/20.
//

import UIKit

class BookRecordViewController: RecordViewController {

    // MARK: View properties
    @IBOutlet private var datePicker: UIDatePicker!

    // MARK: Logic properties
    var bookingLogic: RestaurantBookingLogic!
    
    override func setUpViews() {
        guard let bookRecord = record as? BookRecord else {
            return
        }

        super.setUpViews()
        
        if !PermissionsManager.checkPermissions(Permission.acceptBooking) {
            hideActionButton()
        }

        datePicker.date = bookRecord.time
    }

    @IBAction override func handleAdmit(_ sender: Any) {
        guard let bookRecord = record as? BookRecord else {
            return
        }

        spinner = showSpinner(onView: view)
        bookingLogic.admitCustomer(record: bookRecord,
                                   completion: self.didUpdateRecord)
    }

    @IBAction override func handleServe(_ sender: Any) {
        guard let bookRecord = record as? BookRecord else {
            return
        }

        spinner = showSpinner(onView: view)
        bookingLogic.serveCustomer(record: bookRecord,
                                   completion: self.didUpdateRecord)

    }

    // TODO: add reject button 
    @IBAction override func handleReject(_ sender: Any) {
        guard let bookRecord = record as? BookRecord else {
            return
        }
    
        spinner = showSpinner(onView: view)
        bookingLogic.rejectCustomer(record: bookRecord,
                                    completion: self.didUpdateRecord)
    }
}

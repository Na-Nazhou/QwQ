//
//  EditBookingViewController.swift
//  QwQ
//
//  Created by Tan Su Yee on 15/3/20.
//

import UIKit

class EditBookingViewController: EditRecordViewController, RecordDelegate {

    @IBOutlet var datePicker: UIDatePicker!

    @IBAction override func handleSubmit(_ sender: Any) {
        guard super.checkRecordDetails() else {
            return
        }

        guard let groupSize = groupSize,
                       let babyChairQuantity = babyChairQuantity  else {
                    return
            }

        spinner = showSpinner(onView: view)
        
        // Edit existing book record
        if let bookRecord = record as? BookRecord {
            CustomerBookingLogicManager.shared()
                .editBookRecord(oldRecord: bookRecord,
                                at: datePicker.date,
                                with: groupSize,
                                babyChairQuantity: babyChairQuantity,
                                wheelchairFriendly: wheelchairFriendlySwitch.isOn)
            return
        }

        // Create a new book record
        guard let restaurant = RestaurantLogicManager.shared().currentRestaurant else {
            return
        }

        CustomerBookingLogicManager.shared()
            .addBookRecord(to: restaurant,
                           at: datePicker.date,
                           with: groupSize,
                           babyChairQuantity: babyChairQuantity,
                           wheelchairFriendly: wheelchairFriendlySwitch.isOn)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        CustomerBookingLogicManager.shared().bookingDelegate = self
    }

    override func setUpViews() {
        super.setUpViews()

        let minDate = Date()
        datePicker.minimumDate = minDate

        // Editing an existing book record
        if let bookRecord = record as? BookRecord {
            datePicker.date = bookRecord.time
        } else {
            datePicker.date = minDate
        }
    }
}

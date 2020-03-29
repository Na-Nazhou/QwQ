//
//  EditBookingViewController.swift
//  QwQ
//
//  Created by Tan Su Yee on 15/3/20.
//

import UIKit

class EditBookingViewController: EditRecordViewController, BookingDelegate {

    @IBOutlet var datePicker: UIDatePicker!

    @IBAction override func handleSubmit(_ sender: Any) {
        guard super.checkRecordDetails() else {
            return
        }

        guard let groupSize = groupSize,
            let babyChairQuantity = babyChairQuantity  else {
                    return
        }
        
        // Edit existing book record
        if let bookRecord = record as? BookRecord {
            if CustomerBookingLogicManager.shared()
                .editBookRecord(oldRecord: bookRecord,
                                at: datePicker.date,
                                with: groupSize,
                                babyChairQuantity: babyChairQuantity,
                                wheelchairFriendly: wheelchairFriendlySwitch.isOn) {
                spinner = showSpinner(onView: view)
            }
            return
        }

        // Create a new book record
        guard let restaurant = RestaurantLogicManager.shared().currentRestaurant else {
            return
        }

        if CustomerBookingLogicManager.shared()
            .addBookRecord(to: restaurant,
                           at: datePicker.date,
                           with: groupSize,
                           babyChairQuantity: babyChairQuantity,
                           wheelchairFriendly: wheelchairFriendlySwitch.isOn) {
            spinner = showSpinner(onView: view)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        CustomerBookingLogicManager.shared().bookingDelegate = self
    }

    override func setUpViews() {
        super.setUpViews()

        let calendar = Calendar.current
        let minuteInterval = 15
        let twoHoursLater = calendar.date(byAdding: .hour, value: 2, to: Date.getCurrentTime())!
        let offset = minuteInterval - calendar.component(.minute, from: twoHoursLater) % minuteInterval
        let minDate = calendar.date(byAdding: .minute, value: offset, to: twoHoursLater)!

        datePicker.minimumDate = minDate
        datePicker.minuteInterval = minuteInterval

        // Editing an existing book record
        if let bookRecord = record as? BookRecord {
            datePicker.date = bookRecord.time
        } else {
            datePicker.date = minDate
        }
    }

    func didFindExistingRecord() {
        showMessage(title: Constants.errorTitle,
                    message: "You have an existing booking at the same time at this restaurant already!",
                    buttonText: Constants.okayTitle)
    }
}

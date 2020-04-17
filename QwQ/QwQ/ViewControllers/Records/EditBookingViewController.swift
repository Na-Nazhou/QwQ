//
//  EditBookingViewController.swift
//  QwQ
//
//  Created by Tan Su Yee on 15/3/20.
//

import UIKit

class EditBookingViewController: EditRecordViewController, BookingDelegate {

    // MARK: View properties
    @IBOutlet var datePicker: UIDatePicker!

    var advanceBookingLimit: Int {
        restaurants.map { $0.advanceBookingLimit }.max() ?? 2
    }

    // MARK: Logic properties
    var bookingLogicManager: CustomerBookingLogic!

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
            if bookingLogicManager.editBookRecord(oldRecord: bookRecord,
                                               at: datePicker.date,
                                               with: groupSize,
                                               babyChairQuantity: babyChairQuantity,
                                               wheelchairFriendly: wheelchairFriendlySwitch.isOn) {
                spinner = showSpinner(onView: view)
            }
            return
        }

        // Create a new book record
        if bookingLogicManager.addBookRecords(to: restaurants,
                                              at: datePicker.date,
                                              with: groupSize,
                                              babyChairQuantity: babyChairQuantity,
                                              wheelchairFriendly: wheelchairFriendlySwitch.isOn) {
            spinner = showSpinner(onView: view)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bookingLogicManager.bookingDelegate = self
    }

    override func setUpViews() {
        super.setUpViews()

        let calendar = Calendar.current
        let minuteInterval = 15
        let earliestBookingTime = calendar.date(byAdding: .hour, value: advanceBookingLimit,
                                                to: Date.getCurrentTime())!
        let offset = minuteInterval - calendar.component(.minute, from: earliestBookingTime) % minuteInterval
        let minDate = calendar.date(byAdding: .minute, value: offset, to: earliestBookingTime)!

        datePicker.minimumDate = minDate
        datePicker.minuteInterval = minuteInterval

        // Editing an existing book record
        if let bookRecord = record as? BookRecord {
            datePicker.date = bookRecord.time
        } else {
            datePicker.date = minDate
        }
    }

    func didFindExistingRecord(at restaurant: Restaurant) {
        showMessage(title: Constants.errorTitle,
                    message: String(format: Constants.alreadyBookRestaurantMessage, restaurant.name),
                    buttonText: Constants.okayTitle)
    }

    func didExceedAdvanceBookingLimit(at restaurant: Restaurant) {
        showMessage(title: Constants.errorTitle,
                    message: String(format: Constants.exceedAdvanceBookingLimitMessage,
                                    restaurant.advanceBookingLimit, restaurant.name),
                    buttonText: Constants.okayTitle)
    }

    func didExceedOperatingHours(at restaurant: Restaurant) {
        showMessage(title: Constants.errorTitle,
                    message: String(format: Constants.exceedOperatingHoursMessage,
                                    restaurant.name, restaurant.operatingHours),
                    buttonText: Constants.okayTitle)
    }
}

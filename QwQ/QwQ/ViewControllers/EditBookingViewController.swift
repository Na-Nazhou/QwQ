//
//  EditBookingViewController.swift
//  QwQ
//
//  Created by Tan Su Yee on 15/3/20.
//

import UIKit

class EditBookingViewController: UIViewController, BookingDelegate {
    @IBOutlet private var nameTextField: UITextField!
    @IBOutlet private var contactTextField: UITextField!
    @IBOutlet private var groupSizeTextField: UITextField!
    @IBOutlet private var babyChairQuantityTextField: UITextField!
    @IBOutlet private var datePicker: UIDatePicker!
    @IBOutlet private var wheelchairFriendlySwitch: UISwitch!
    @IBOutlet private var restaurantNameLabel: UILabel!

    var spinner: UIView?
    
    var bookRecord: BookRecord?

    @IBAction private func handleBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction private func handleSubmit(_ sender: Any) {
        guard let groupSizeText = groupSizeTextField.text,
                let babyChairQueantityText = babyChairQuantityTextField.text,
                let groupSize = Int(groupSizeText.trimmingCharacters(in: .newlines)),
                let babyChairQuantity = Int(babyChairQueantityText.trimmingCharacters(in: .newlines)) else {
                    showMessage(title: Constants.errorTitle,
                                message: "Missing fields",
                                buttonText: Constants.okayTitle,
                                buttonAction: nil)
                    return
            }

        spinner = showSpinner(onView: view)
        
        // Edit existing book record
        if let bookRecord = bookRecord {
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
        
        self.registerObserversForKeyboard()
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setUpViews()
    }
    
    private func setUpViews() {
        // Set up an existing book record
        if let bookRecord = bookRecord {
            restaurantNameLabel.text = bookRecord.restaurant.name
            nameTextField.text = bookRecord.customer.name
            contactTextField.text = bookRecord.customer.contact

            datePicker.date = bookRecord.time
            groupSizeTextField.text = String(bookRecord.groupSize)
            babyChairQuantityTextField.text = String(bookRecord.babyChairQuantity)
            wheelchairFriendlySwitch.isOn = bookRecord.wheelchairFriendly
        } else {
            guard let restaurant = RestaurantLogicManager.shared().currentRestaurant else {
                return
            }
            restaurantNameLabel.text = restaurant.name
            
            // Autofill the name and contact
            nameTextField.text = CustomerQueueLogicManager.shared().customer.name
            contactTextField.text = CustomerQueueLogicManager.shared().customer.contact

            // TODO: allow restaurants to set this
            let minDate = Date()
            datePicker.minimumDate = minDate
            datePicker.date = minDate

            wheelchairFriendlySwitch.isOn = Constants.defaultWheelchairFriendly
            babyChairQuantityTextField.text = String(Constants.defaultBabyChairQuantity)
        }
        
        // Disable name and contact fields
        nameTextField.isEnabled = false
        contactTextField.isEnabled = false
    }
    
    // TODO: go to activities view controller instead
    func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func didAddBookRecord() {
        removeSpinner(spinner)
        showMessage(
            title: Constants.successTitle,
            message: Constants.bookRecordCreateSuccessMessage,
            buttonText: Constants.okayTitle,
            buttonAction: {_ in
                self.goBack()
            }
        )
    }
    
    func didUpdateBookRecord() {
        removeSpinner(spinner)
        showMessage(
            title: Constants.successTitle,
            message: Constants.bookRecordUpdateSuccessMessage,
            buttonText: Constants.okayTitle,
            buttonAction: {_ in
                self.goBack()
            }
        )
    }
}

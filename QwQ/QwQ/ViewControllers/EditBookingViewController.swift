//
//  EditBookingViewController.swift
//  QwQ
//
//  Created by Tan Su Yee on 15/3/20.
//

import UIKit

<<<<<<< Updated upstream
class EditBookingViewController: UIViewController {
    @IBOutlet private var nameTextField: UITextField!
    @IBOutlet private var contactTextField: UITextField!
    @IBOutlet private var groupSizeTextField: UITextField!
    @IBOutlet private var babyChairQuantityTextField: UITextField!
    @IBOutlet private var datePicker: UIDatePicker!
    @IBOutlet private var wheelchairFriendlySwitch: UISwitch!
    @IBOutlet private var restaurantNameLabel: UILabel!
    
    var bookRecord: BookRecord?
    var spinner: UIView?
=======
class EditBookingViewController: UIViewController, BookingDelegate, RecordViewController {
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var contactTextField: UITextField!
    @IBOutlet var groupSizeTextField: UITextField!
    @IBOutlet var babyChairQuantityTextField: UITextField!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var wheelchairFriendlySwitch: UISwitch!
    @IBOutlet var restaurantNameLabel: UILabel!

    var spinner: UIView?
    
    var record: Record?
>>>>>>> Stashed changes

    @IBAction private func handleBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    // TODO
    @IBAction private func handleSubmit(_ sender: Any) {
        guard let restaurant = RestaurantLogicManager.shared().currentRestaurant,
                let groupSizeText = groupSizeTextField.text,
                let babyChairQueantityText = babyChairQuantityTextField.text,
                let groupSize = Int(groupSizeText.trimmingCharacters(in: .newlines)),
                let babyChairQuantity = Int(babyChairQueantityText.trimmingCharacters(in: .newlines)) else {
                    showMessage(title: Constants.errorTitle,
                                message: "Invalid data",
                                buttonText: Constants.okayTitle,
                                buttonAction: nil)
                    return
            }

//        spinner = showSpinner(onView: view)
        
        // Edit existing book record
<<<<<<< Updated upstream
        if bookRecord != nil {
            // TODO
=======
        if let bookRecord = record as? BookRecord {
            CustomerBookingLogicManager.shared()
                .editBookRecord(oldRecord: bookRecord,
                                at: datePicker.date,
                                with: groupSize,
                                babyChairQuantity: babyChairQuantity,
                                wheelchairFriendly: wheelchairFriendlySwitch.isOn)
            return
>>>>>>> Stashed changes
        }

        // Create a new book record
        // TODO
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.registerObserversForKeyboard()
        self.hideKeyboardWhenTappedAround()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setUpViews()
    }
    
    private func setUpViews() {
        // Editing an existing book record
<<<<<<< Updated upstream
        if let bookRecord = bookRecord {
            restaurantNameLabel.text = bookRecord.restaurant.name
            nameTextField.text = bookRecord.customer.name
            contactTextField.text = bookRecord.customer.contact
            
            groupSizeTextField.text = String(bookRecord.groupSize)
            babyChairQuantityTextField.text = String(bookRecord.babyChairQuantity)
            wheelchairFriendlySwitch.isOn = bookRecord.wheelchairFriendly
=======
        if let bookRecord = record as? BookRecord {
            setUpRecordView()
            datePicker.date = bookRecord.time

>>>>>>> Stashed changes
        } else {
            guard let restaurant = RestaurantLogicManager.shared().currentRestaurant else {
                return
            }
            restaurantNameLabel.text = restaurant.name
            
            // Autofill the name and contact
            nameTextField.text = CustomerQueueLogicManager.shared().customer.name
            contactTextField.text = CustomerQueueLogicManager.shared().customer.contact
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

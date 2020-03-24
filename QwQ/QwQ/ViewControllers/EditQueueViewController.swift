//
//  EditQueueViewController.swift
//  QwQ
//
//  Created by Tan Su Yee on 15/3/20.
//

import UIKit

class EditQueueViewController: UIViewController, QueueDelegate {
    @IBOutlet private var nameTextField: UITextField!
    @IBOutlet private var contactTextField: UITextField!
    @IBOutlet private var groupSizeTextField: UITextField!
    @IBOutlet private var babyChairQuantityTextField: UITextField!
    @IBOutlet private var wheelchairFriendlySwitch: UISwitch!
    @IBOutlet private var restaurantNameLabel: UILabel!

    var spinner: UIView?

    var queueRecord: QueueRecord? 
    
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

        // Edit existing queue record
        if let queueRecord = queueRecord {
            CustomerQueueLogicManager.shared()
                .editQueueRecord(oldRecord: queueRecord,
                                 with: groupSize,
                                 babyChairQuantity: babyChairQuantity,
                                 wheelchairFriendly: wheelchairFriendlySwitch.isOn)
            return
        }

         // Create a new queue record
        guard let restaurant = RestaurantLogicManager.shared().currentRestaurant else {
            return
        }
        CustomerQueueLogicManager.shared()
            .enqueue(to: restaurant,
                     with: groupSize,
                     babyChairQuantity: babyChairQuantity,
                     wheelchairFriendly: wheelchairFriendlySwitch.isOn)
    }
    
    @IBAction private func handleBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        CustomerQueueLogicManager.shared().queueDelegate = self
        
        self.registerObserversForKeyboard()
        self.hideKeyboardWhenTappedAround()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setUpViews()
    }

    private func setUpViews() {
        // Set up an existing queue record
        if let queueRecord = queueRecord {
            restaurantNameLabel.text = queueRecord.restaurant.name
            nameTextField.text = queueRecord.customer.name
            contactTextField.text = queueRecord.customer.contact

            groupSizeTextField.text = String(queueRecord.groupSize)
            babyChairQuantityTextField.text = String(queueRecord.babyChairQuantity)
            wheelchairFriendlySwitch.isOn = queueRecord.wheelchairFriendly
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

    func didAddQueueRecord() {
        removeSpinner(spinner)
        showMessage(
            title: Constants.successTitle,
            message: Constants.queueRecordCreateSuccessMessage,
            buttonText: Constants.okayTitle,
            buttonAction: {_ in
                self.goBack()
            })
    }

    func didUpdateQueueRecord() {
        removeSpinner(spinner)
        showMessage(
            title: Constants.successTitle,
            message: Constants.queueRecordUpdateSuccessMessage,
            buttonText: Constants.okayTitle,
            buttonAction: {_ in
                self.goBack()
            })
    }
}

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

    var queueRecord: QueueRecord? {
        CustomerQueueLogicManager.shared().currentQueueRecord
    }
    
    @IBAction private func handleSubmit(_ sender: Any) {
        guard let restaurant = RestaurantLogicManager.shared().currentRestaurant,
            let groupSizeText = groupSizeTextField.text,
            let babyChairQueantityText = babyChairQuantityTextField.text,
            let groupSize = Int(groupSizeText),
            let babyChairQuantity = Int(babyChairQueantityText) else {
            return
        }

        // Edit existing queue record
        if queueRecord != nil {
            CustomerQueueLogicManager.shared()
            .editQueueRecord(with: groupSize,
                             babyChairQuantity: babyChairQuantity,
                             wheelchairFriendly: wheelchairFriendlySwitch.isOn)
        }

        // Create a new queue record
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
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        setUpViews()
    }

    private func setUpViews() {
        // Editing an existing queue record
        if let queueRecord = queueRecord {
            restaurantNameLabel.text = queueRecord.restaurant.name
            nameTextField.text = queueRecord.customer.name
            contactTextField.text = queueRecord.customer.contact
            groupSizeTextField.text = String(queueRecord.groupSize)
            babyChairQuantityTextField.text = String(queueRecord.babyChairQuantity)
            wheelchairFriendlySwitch.isOn = queueRecord.wheelchairFriendly
        } else { // Auto fill the name and contact
            guard let restaurant = RestaurantLogicManager.shared().currentRestaurant else {
                return
            }
            restaurantNameLabel.text = restaurant.name
            nameTextField.text = CustomerQueueLogicManager.shared().customer.name
            contactTextField.text = CustomerQueueLogicManager.shared().customer.contact
        }
    }

    func didAddQueueRecord() {
        showMessage(
            title: Constants.successfulUpdateTitle,
            message: Constants.successQueueRecordCreationMessage,
            buttonText: Constants.okayTitle,
            buttonAction: {_ in
                self.navigationController?.popViewController(animated: true)
            })
    }

    func didUpdateQueueRecord() {
        showMessage(
            title: Constants.successfulUpdateTitle,
            message: Constants.successQueueRecordUpdateMessage,
            buttonText: Constants.okayTitle,
            buttonAction: {_ in
                self.navigationController?.popViewController(animated: true)
            })
    }
}

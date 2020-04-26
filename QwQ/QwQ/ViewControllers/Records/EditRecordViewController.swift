/**
`EditRecordViewController` enables editing of a queue or book record.
*/

import UIKit

class EditRecordViewController: UIViewController {

    // MARK: View properties
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var contactTextField: UITextField!
    @IBOutlet var groupSizeTextField: UITextField!
    @IBOutlet var babyChairQuantityTextField: UITextField!
    @IBOutlet var wheelchairFriendlySwitch: UISwitch!
    @IBOutlet var restaurantNameLabel: UILabel!

    var spinner: UIView?

    // MARK: Logic properties
    // For creating records
    var restaurantLogic: RestaurantLogic?

    // MARK: Model properties
    // For editing a record
    var record: Record?

    // For creating records
    var restaurants: [Restaurant] {
        restaurantLogic?.currentRestaurants ?? []
    }

    var groupSize: Int? {
        guard let groupSizeText = groupSizeTextField.text else {
            return nil
        }
        return Int(groupSizeText.trimmingCharacters(in: .newlines))
    }

    var babyChairQuantity: Int? {
        guard let babyChairQuantityText = babyChairQuantityTextField.text else {
            return nil
        }
        return Int(babyChairQuantityText.trimmingCharacters(in: .newlines))
    }

    @IBAction func handleBack(_ sender: Any) {
        handleBack()
    }

    @IBAction func handleSubmit(_ sender: Any) {
        fatalError("Not implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.registerObserversForKeyboard()
        self.hideKeyboardWhenTappedAround()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setUpViews()
    }

    func setUpViews() {
        if let record = record {
            restaurantNameLabel.text = record.restaurant.name
            nameTextField.text = record.customer.name
            contactTextField.text = record.customer.contact
            groupSizeTextField.text = String(record.groupSize)
            babyChairQuantityTextField.text = String(record.babyChairQuantity)
            wheelchairFriendlySwitch.isOn = record.wheelchairFriendly
        } else {
            restaurantNameLabel.text = restaurants.map({ $0.name }).joined(separator: ", ")

            // Autofill the name and contact
            nameTextField.text = CustomerActivity.shared().customer.name
            contactTextField.text = CustomerActivity.shared().customer.contact
            wheelchairFriendlySwitch.isOn = Constants.defaultWheelchairFriendly
            babyChairQuantityTextField.text = String(Constants.defaultBabyChairQuantity)
        }

        // Disable name and contact fields
        nameTextField.isEnabled = false
        contactTextField.isEnabled = false
    }

    /// Display add record success message
    func didAddRecord() {
        showMessage(
            title: Constants.successTitle,
            message: Constants.recordCreateSuccessMessage,
            buttonText: Constants.okayTitle,
            buttonAction: {_ in
                self.handleBack()
            })
    }

    /// Display add record(s) success message
    /// - Parameter newRecords: created records
    func didAddRecords(_ newRecords: [Record]) {
        guard !newRecords.isEmpty else {
            return
        }
        removeSpinner(spinner)
        let message: String
        if newRecords.count == 1 {
            message = Constants.recordCreateSuccessMessage
        } else {
            message = Constants.multipleRecordCreateSuccessMessage
        }
        showMessage(
            title: Constants.successTitle,
            message: message,
            buttonText: Constants.okayTitle,
            buttonAction: {_ in
                self.handleBack()
            })
     }

    /// Display update record success message
    func didUpdateRecord() {
        removeSpinner(spinner)
        showMessage(
            title: Constants.successTitle,
            message: Constants.recordUpdateSuccessMessage,
            buttonText: Constants.okayTitle,
            buttonAction: {_ in
                self.handleBack()
            })
    }

    /// Display withdraw record success message
    func didWithdrawRecord() {
        removeSpinner(spinner)
        showMessage(
            title: Constants.successTitle,
            message: Constants.recordWithdrawSuccessMessage,
            buttonText: Constants.okayTitle,
            buttonAction: { _ in
                self.handleBack()
            })
    }

    /// Validate record details entered by user
    /// - Returns: true if record details are valid, else false
    func checkRecordDetails() -> Bool {
        guard let groupSize = groupSize,
            let babyChairQuantity = babyChairQuantity else {
                showMessage(title: Constants.errorTitle,
                            message: Constants.missingRecordFieldsTitle,
                            buttonText: Constants.okayTitle)
                return false
        }

        // Group size must be at least 1
        if groupSize <= 0 {
            showMessage(title: Constants.errorTitle,
                        message: Constants.groupSizeErrorMessage,
                        buttonText: Constants.okayTitle)
            return false
        }

        // Group size must be more than baby chair quantity
        if groupSize < babyChairQuantity {
            showMessage(title: Constants.errorTitle,
                        message: Constants.groupSizeBabyChairErrorMessage,
                        buttonText: Constants.okayTitle)
            return false
        }

        // Group size must be equal to or more than minimum group size
        if !(restaurants.allSatisfy { groupSize >= $0.minGroupSize }) {
            showMessage(title: Constants.errorTitle,
                        message: Constants.groupSizeMinSizeMessage,
                        buttonText: Constants.okayTitle)
            return false
        }

        // Group size must be equal to or less than maximum group size
        if !(restaurants.allSatisfy { groupSize <= $0.maxGroupSize }) {
             showMessage(title: Constants.errorTitle,
                         message: Constants.groupSizeMaxSizeMessage,
                         buttonText: Constants.okayTitle)
        }

        return true
    }
}

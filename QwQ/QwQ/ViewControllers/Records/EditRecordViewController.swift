import UIKit

class EditRecordViewController: UIViewController {
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var contactTextField: UITextField!
    @IBOutlet var groupSizeTextField: UITextField!
    @IBOutlet var babyChairQuantityTextField: UITextField!
    @IBOutlet var wheelchairFriendlySwitch: UISwitch!
    @IBOutlet var restaurantNameLabel: UILabel!

    var spinner: UIView?

    var restaurantLogicManager: RestaurantLogicManager?
    var restaurant: Restaurant? {
        restaurantLogicManager?.currentRestaurant
    }
    var record: Record?

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
            guard let restaurant = restaurant else {
                return
            }
            restaurantNameLabel.text = restaurant.name

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

     func didAddRecord() {
         removeSpinner(spinner)
         showMessage(
             title: Constants.successTitle,
             message: Constants.recordCreateSuccessMessage,
             buttonText: Constants.okayTitle,
             buttonAction: {_ in
                 self.handleBack()
             })
     }

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

    func checkRecordDetails() -> Bool {
        guard let groupSize = groupSize,
            let babyChairQuantity = babyChairQuantity else {
                showMessage(title: Constants.errorTitle,
                            message: "Missing fields",
                            buttonText: Constants.okayTitle)
                return false
        }

        if groupSize < babyChairQuantity {
            showMessage(title: Constants.errorTitle,
                        message: "Group size must be greater than baby chair quantity!",
                        buttonText: Constants.okayTitle)
            return false
        }

        return true
    }
}

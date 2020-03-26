import UIKit

class EditRecordViewController: UIViewController {
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var contactTextField: UITextField!
    @IBOutlet var groupSizeTextField: UITextField!
    @IBOutlet var babyChairQuantityTextField: UITextField!
    @IBOutlet var wheelchairFriendlySwitch: UISwitch!
    @IBOutlet var restaurantNameLabel: UILabel!

    var spinner: UIView?

    var record: Record?

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

     func didAddRecord() {
         removeSpinner(spinner)
         showMessage(
             title: Constants.successTitle,
             message: Constants.recordCreateSuccessMessage,
             buttonText: Constants.okayTitle,
             buttonAction: {_ in
                 self.goBack()
             })
     }

     func didUpdateRecord() {
         removeSpinner(spinner)
         showMessage(
             title: Constants.successTitle,
             message: Constants.recordUpdateSuccessMessage,
             buttonText: Constants.okayTitle,
             buttonAction: {_ in
                 self.goBack()
             })
     }
}

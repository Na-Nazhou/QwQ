//
//  EditBookingViewController.swift
//  QwQ
//
//  Created by Tan Su Yee on 15/3/20.
//

import UIKit

class EditBookingViewController: UIViewController {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var contactTextField: UITextField!
    @IBOutlet weak var groupSizeTextField: UITextField!
    @IBOutlet weak var babyChairQuantityTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var wheelchairFriendlySwitch: UISwitch!
    @IBOutlet weak var restaurantNameLabel: UILabel!
    
    @IBAction func handleBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func handleSubmit(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.registerObserversForKeyboard()
        self.hideKeyboardWhenTappedAround()
    }
}

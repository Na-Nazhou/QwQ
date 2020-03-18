//
//  EditBookingViewController.swift
//  QwQ
//
//  Created by Tan Su Yee on 15/3/20.
//

import UIKit

class EditBookingViewController: UIViewController {
    @IBOutlet private var nameTextField: UITextField!
    @IBOutlet private var contactTextField: UITextField!
    @IBOutlet private var groupSizeTextField: UITextField!
    @IBOutlet private var babyChairQuantityTextField: UITextField!
    @IBOutlet private var datePicker: UIDatePicker!
    @IBOutlet private var wheelchairFriendlySwitch: UISwitch!
    @IBOutlet private var restaurantNameLabel: UILabel!

    // TODO: fix
    var bookRecord: QueueRecord?

    @IBAction private func handleBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction private func handleSubmit(_ sender: Any) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

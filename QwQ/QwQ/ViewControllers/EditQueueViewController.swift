//
//  EditQueueViewController.swift
//  QwQ
//
//  Created by Tan Su Yee on 15/3/20.
//

import UIKit

class EditQueueViewController: UIViewController {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var contactTextField: UITextField!
    @IBOutlet weak var groupSizeTextField: UITextField!
    @IBOutlet weak var babyChairQuantityTextField: UITextField!
    @IBOutlet weak var wheelchairFriendlySwitch: UISwitch!
    
    @IBAction func handleSubmit(_ sender: Any) {
    }
    
    @IBAction func handleBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

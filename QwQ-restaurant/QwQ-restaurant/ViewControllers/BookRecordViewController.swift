//
//  BookRecordViewController.swift
//  QwQ-restaurant
//
//  Created by Tan Su Yee on 18/3/20.
//

import UIKit

class BookRecordViewController: UIViewController {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var contactLabel: UILabel!
    @IBOutlet weak var groupSizeLabel: UILabel!
    @IBOutlet weak var babyChairQuantityLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var wheelchairFriendlySwitch: UISwitch!
    
    var bookRecord: QueueRecord?
    
    @IBAction func handleAdmit(_ sender: Any) {
        showMessage(title: Constants.admitCustomerTitle, message: Constants.admitCustomerMessage, buttonText: Constants.okayTitle)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViews()
    }
    
    @IBAction func handleBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    private func setUpViews() {
        nameLabel.text = bookRecord?.customer.name
        contactLabel.text = bookRecord?.customer.contact
        groupSizeLabel.text = String(bookRecord?.groupSize ?? 0)
        babyChairQuantityLabel.text = String(bookRecord?.wheelchairFriendly ?? false)
        wheelchairFriendlySwitch.isOn = bookRecord?.wheelchairFriendly ?? false
    }
    
    func showMessage(title: String, message: String, buttonText: String) {
        let message = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let closeDialogAction = UIAlertAction(title: buttonText, style: .default)
        message.addAction(closeDialogAction)
        
        self.present(message, animated: true)
    }
}


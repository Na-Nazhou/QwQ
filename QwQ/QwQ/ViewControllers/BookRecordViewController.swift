//
//  BookRecordViewController.swift
//  QwQ
//
//  Created by Tan Su Yee on 18/3/20.
//

import UIKit

class BookRecordViewController: UIViewController, DisplayRecordViewController {
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var contactLabel: UILabel!
    @IBOutlet var groupSizeLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var babyChairQuantityLabel: UILabel!
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var wheelchairFriendlySwitch: UISwitch!
    @IBOutlet var datePicker: UIDatePicker!

    var record: Record?
    typealias Profile = FBProfileStorage

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViews()
    }
    
    @IBAction private func handleBack(_ sender: Any) {
        handleBack()
    }
    
    private func setUpViews() {
        guard let bookRecord = record as? BookRecord else {
            return
        }
        setUpRecordView()
        datePicker.date = bookRecord.time
        datePicker.isEnabled = false

        Profile.getCustomerProfilePic(uid: bookRecord.restaurant.uid, placeholder: profileImageView)
    }
}

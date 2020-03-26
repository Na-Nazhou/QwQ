//
//  BookRecordViewController.swift
//  QwQ-restaurant
//
//  Created by Tan Su Yee on 18/3/20.
//

import UIKit

class BookRecordViewController: UIViewController, RecordViewController {
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var contactLabel: UILabel!
    @IBOutlet var groupSizeLabel: UILabel!
    @IBOutlet var babyChairQuantityLabel: UILabel!
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var wheelchairFriendlySwitch: UISwitch!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var actionButton: UIButton!

    var record: Record?

    var spinner: UIView?

    @IBAction private func handleAdmit(_ sender: Any) {
        guard let bookRecord = record as? BookRecord else {
            return
        }
        self.spinner = self.showSpinner(onView: self.view)
        RestaurantQueueLogicManager.shared()
            .admitCustomer(record: bookRecord,
                           completion: self.didUpdateRecord)
    }

    @IBAction private func handleServe(_ sender: Any) {
        guard let bookRecord = record as? BookRecord else {
            return
        }
        self.spinner = self.showSpinner(onView: self.view)
        RestaurantQueueLogicManager.shared()
            .serveCustomer(record: bookRecord,
                           completion: self.didUpdateRecord)

    }

    func didUpdateRecord() {
        removeSpinner(spinner)
        handleBack()
    }
    
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

        if bookRecord.isPendingAdmission {
            setUpAdmitButton()
        }

        if bookRecord.isAdmitted {
            setUpServeButton()
        }

        if bookRecord.isHistoryRecord {
            hideActionButton()
        }
    }

    private func setUpAdmitButton() {
        actionButton.setTitle("ADMIT", for: .normal)
        actionButton.addTarget(self, action: #selector(handleAdmit), for: .touchUpInside)
    }

    private func setUpServeButton() {
        actionButton.setTitle("SERVE", for: .normal)
        actionButton.addTarget(self, action: #selector(handleServe), for: .touchUpInside)
    }

    private func hideActionButton() {
        actionButton.isHidden = true
    }
}

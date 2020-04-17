//
//  DisplayRecordViewController.swift
//  QwQ
//
//  Created by Daniel Wong on 25/3/20.
//

import UIKit

class RecordViewController: UIViewController {

    // MARK: View properties
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var contactLabel: UILabel!
    @IBOutlet var groupSizeLabel: UILabel!
    @IBOutlet var babyChairQuantityLabel: UILabel!
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var wheelchairFriendlySwitch: UISwitch!
    @IBOutlet var actionButton: UIButton!

    var spinner: UIView?

    // MARK: Model properties
    var record: Record?

    override func viewDidLoad() {
           super.viewDidLoad()

           setUpViews()
    }
    
    func setUpViews() {
        if let record = record {
            nameLabel.text = record.customer.name
            contactLabel.text = record.customer.contact
            groupSizeLabel.text = String(record.groupSize)
            babyChairQuantityLabel.text = String(record.babyChairQuantity)
            wheelchairFriendlySwitch.isOn = record.wheelchairFriendly
            FIRRestaurantStorage.getRestaurantProfilePic(uid: record.customer.uid, placeholder: profileImageView)

            if record.isPendingAdmission {
                setUpAdmitButton()
            }

            if record.isAdmitted {
                setUpPendingConfirmationButton()
            }

            if record.isConfirmedAdmission {
                setUpServeButton()
            }

            if record.isHistoryRecord {
                hideActionButton()
            }
        }
    }

    @IBAction func handleBack(_ sender: Any) {
        handleBack()
    }

    func didUpdateRecord() {
        removeSpinner(spinner)
        handleBack()
    }

    @IBAction func handleAdmit(_ sender: Any) {
        fatalError("Not implemented")
    }

    @IBAction func handleServe(_ sender: Any) {
        fatalError("Not implemented")
    }

    @IBAction func handleReject(_ sender: Any) {
        fatalError("Not implemented")
    }

    private func setUpAdmitButton() {
        actionButton.setTitle("ADMIT", for: .normal)
        actionButton.addTarget(self, action: #selector(handleAdmit), for: .touchUpInside)
    }

    private func setUpServeButton() {
        actionButton.setTitle("SERVE", for: .normal)
        actionButton.addTarget(self, action: #selector(handleServe), for: .touchUpInside)
    }

    private func setUpPendingConfirmationButton() {
        actionButton.setTitle("PENDING CONFIRMATION", for: .normal)
        actionButton.alpha = 0.5
        actionButton.isEnabled = false
    }

    // TODO
    private func setUpRejectButton() {
        actionButton.setTitle("REJECT", for: .normal)
        actionButton.addTarget(self, action: #selector(handleReject), for: .touchUpInside)
    }

    private func hideActionButton() {
        actionButton.isHidden = true
    }
}

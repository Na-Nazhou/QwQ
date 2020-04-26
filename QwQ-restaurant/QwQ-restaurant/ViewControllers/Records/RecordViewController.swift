//
//  DisplayRecordViewController.swift
//  QwQ
//
//  Created by Daniel Wong on 25/3/20.
//

/**
`RecordViewController` shows full record details of a queue or book record.
*/

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
    
    /// Set up record cell details
    func setUpViews() {
        guard let record = record else {
            return
        }

        nameLabel.text = record.customer.name
        contactLabel.text = record.customer.contact
        groupSizeLabel.text = String(record.groupSize)
        babyChairQuantityLabel.text = String(record.babyChairQuantity)
        wheelchairFriendlySwitch.isOn = record.wheelchairFriendly
        FIRRestaurantStorage.getRestaurantProfilePic(uid: record.customer.uid, placeholder: profileImageView)

        // Only show admit button if record is missed or pending admit
        if record.isPendingAdmission || record.isMissedAndPending {
            setUpAdmitButton()
        }

        // Only show pending confirmation button if record is admitted
        if record.isAdmitted {
            setUpPendingConfirmationButton()
        }

        // Only show serve button if record is confirmed admitted
        if record.isConfirmedAdmission {
            setUpServeButton()
        }

        // Do not show any buttons for past records
        if record.isHistoryRecord {
            hideActionButton()
        }
    }
    
    func hideActionButton() {
        actionButton.isHidden = true
    }
    
    func didUpdateRecord() {
        removeSpinner(spinner)
        handleBack()
    }

    @IBAction func handleBack(_ sender: Any) {
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
        actionButton.setTitle(Constants.admitButtonTitle, for: .normal)
        actionButton.addTarget(self, action: #selector(handleAdmit), for: .touchUpInside)
    }

    private func setUpServeButton() {
        actionButton.setTitle(Constants.serveButtonTitle, for: .normal)
        actionButton.addTarget(self, action: #selector(handleServe), for: .touchUpInside)
    }

    private func setUpPendingConfirmationButton() {
        actionButton.setTitle(Constants.pendingConfirmationButtonTitle, for: .normal)
        actionButton.alpha = Constants.pendingConfirmationButtonAlpha
        actionButton.isEnabled = false
    }

    private func setUpRejectButton() {
        actionButton.setTitle(Constants.rejectButtonTitle, for: .normal)
        actionButton.addTarget(self, action: #selector(handleReject), for: .touchUpInside)
    }
}

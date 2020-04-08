//
//  ActivityCell.swift
//  QwQ
//
//  Created by Tan Su Yee on 18/3/20.
//

import UIKit

class ActivityCell: UICollectionViewCell {
    var editAction: (() -> Void)?
    var deleteAction: (() -> Void)?
    var confirmAction: (() -> Void)?

    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!
    @IBOutlet private var leftButton: UIButton!
    @IBOutlet private var rightButton: UIButton!
    @IBOutlet private var statusLabel: UILabel!
    @IBOutlet private var queueBookImageView: UIImageView!
    
    @IBAction private func handleDelete(_ sender: Any) {
        deleteAction?()
    }

    @IBAction private func handleEdit(_ sender: Any) {
        editAction?()
    }

    @IBAction private func handleConfirm(_ sender: Any) {
        confirmAction?()
    }

    func setUpView(record: Record) {
        nameLabel.text = record.restaurant.name
        descriptionLabel.text = "\(record.groupSize) pax"

        setUpDeleteButton()
        enableRightButton()

        switch record.status {
        case .pendingAdmission:
            if let queueRecord = record as? QueueRecord {
                statusLabel.text = "Queued at: \(queueRecord.startTime.toString())"

                // TODO: display estimated time instead
            }
            if let bookRecord = record as? BookRecord {
                statusLabel.text = "Reservation Time: \(bookRecord.time.toString())"
            }
            setUpEditButton()
        case .admitted:
            statusLabel.text = "Admitted at: \(record.admitTime!.toString())"
            setUpConfirmButton()
        case .confirmedAdmission:
            statusLabel.text = "Confirmed at: \(record.confirmAdmissionTime!.toString())"
            setUpConfirmButton()
            disableRightButton()
        case .served:
            statusLabel.text = "Served at: \(record.serveTime!.toString())"
        case .rejected:
            statusLabel.text = "Rejected at: \(record.rejectTime!.toString())"
        case .withdrawn:
            statusLabel.text = "Withdrawn at: \(record.withdrawTime!.toString())"
        default:
            assert(false)
        }

        if record as? QueueRecord != nil {
            queueBookImageView.image = UIImage(named: "c-queue-icon")
        }

        if record as? BookRecord != nil {
            queueBookImageView.image = UIImage(named: "c-book-icon")
        }

        // Hide edit and delete buttons if it is history record
        if record.isHistoryRecord {
            hideActionButtons()
        } else {
            showActionButtons()
        }
    }

    private func disableRightButton() {
        disableButton(button: rightButton)
    }

    private func enableRightButton() {
        enableButton(button: rightButton)
    }

    private func hideActionButtons() {
        leftButton.isHidden = true
        rightButton.isHidden = true
    }

    private func showActionButtons() {
        leftButton.isHidden = false
        rightButton.isHidden = false
    }

    private func enableButton(button: UIButton) {
        button.isEnabled = true
        button.alpha = 1
    }

    private func disableButton(button: UIButton) {
        button.isEnabled = false
        button.alpha = 0.5
    }

    private func setEditButtonText(to title: String) {
        rightButton.setTitle(title, for: .normal)
    }

    private func setUpDeleteButton() {
        leftButton.setTitle("DELETE", for: .normal)
        leftButton.addTarget(self, action: #selector(handleDelete), for: .touchUpInside)
    }

    private func setUpEditButton() {
        rightButton.setTitle("EDIT", for: .normal)
        rightButton.removeTarget(self, action: #selector(handleConfirm), for: .touchUpInside)
        rightButton.addTarget(self, action: #selector(handleEdit), for: .touchUpInside)
    }

    private func setUpConfirmButton() {
        rightButton.setTitle("CONFIRM", for: .normal)
        rightButton.removeTarget(self, action: #selector(handleEdit), for: .touchUpInside)
        rightButton.addTarget(self, action: #selector(handleConfirm), for: .touchUpInside)
    }
}

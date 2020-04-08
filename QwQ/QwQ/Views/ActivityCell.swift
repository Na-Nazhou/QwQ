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

        setUpRecordImage(record: record)

        showActionButtons()
        enableRightButton()
        setUpDeleteButton()

        switch record.status {
        case .pendingAdmission:
            setUpPendingAdmissionRecord(record: record)
        case .admitted:
            setUpAdmittedRecord(record: record)
        case .confirmedAdmission:
            setUpConfirmedRecord(record: record)
        default:
            setUpHistoryRecord(record: record)
        }
    }

    private func setUpPendingAdmissionRecord(record: Record) {
        if let queueRecord = record as? QueueRecord {
            statusLabel.text = "Queued at: \(queueRecord.startTime.toString())"

            if let estimatedAdmitTime = queueRecord.estimatedAdmitTime {
                statusLabel.text = "Estimated admit time: \(estimatedAdmitTime.toString())"
            }
        }
        if let bookRecord = record as? BookRecord {
            statusLabel.text = "Reservation Time: \(bookRecord.time.toString())"
        }
        setUpEditButton()
    }

    private func setUpAdmittedRecord(record: Record) {
        statusLabel.text = "Admitted at: \(record.admitTime!.toString()). Please arrive within 15 minutes"
        if let bookRecord = record as? BookRecord {
            statusLabel.text = "Reservation Time: \(bookRecord.time.toString()) (Admitted)"
        }
        setUpConfirmButton()
    }

    private func setUpConfirmedRecord(record: Record) {
        statusLabel.text = "Admitted at: \(record.admitTime!.toString()) (Confirmed)"
        if let bookRecord = record as? BookRecord {
            statusLabel.text = "Reservation Time: \(bookRecord.time.toString()) (Confirmed)"
        }
        setUpConfirmButton()
        disableRightButton()
    }

    private func setUpHistoryRecord(record: Record) {
        switch record.status {
        case .served:
            statusLabel.text = "Served at: \(record.serveTime!.toString())"
        case .rejected:
            statusLabel.text = "Rejected at: \(record.rejectTime!.toString())"
        case .withdrawn:
            statusLabel.text = "Withdrawn at: \(record.withdrawTime!.toString())"
        default:
            assert(false)
        }
        hideActionButtons()
    }

    private func setUpRecordImage(record: Record) {
        if record as? QueueRecord != nil {
            queueBookImageView.image = UIImage(named: "c-queue-icon")
        }

        if record as? BookRecord != nil {
            queueBookImageView.image = UIImage(named: "c-book-icon")
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

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

    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!
    @IBOutlet private var deleteButton: UIButton!
    @IBOutlet private var editButton: UIButton!
    @IBOutlet private var statusLabel: UILabel!
    @IBOutlet private var queueBookImageView: UIImageView!
    
    @IBAction private func handleDelete(_ sender: Any) {
        deleteAction?()
    }

    @IBAction private func handleEdit(_ sender: Any) {
        editAction?()
    }

    func setUpView(record: Record) {
        nameLabel.text = record.restaurant.name
        descriptionLabel.text = "\(record.groupSize) pax"

        disableEdit()

        switch record.status {
        case .pendingAdmission:
            enableEdit()
            if let queueRecord = record as? QueueRecord {
                statusLabel.text = "Queued at: \(queueRecord.startTime.toString())"

                // TODO: display estimated time instead
            }
            if let bookRecord = record as? BookRecord {
                statusLabel.text = "Reservation Time: \(bookRecord.time.toString())"
            }
        case .admitted:
            statusLabel.text = "Admitted at: \(record.admitTime!.toString())"
        case .served:
            statusLabel.text = "Served at: \(record.serveTime!.toString())"
            hideEditAndDelete()
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
            hideEditAndDelete()
        } else {
            showEditAndDelete()
        }
    }

    private func disableEdit() {
        editButton.isEnabled = false
        editButton.alpha = 0.5
    }

    private func enableEdit() {
        editButton.isEnabled = true
        editButton.alpha = 1
    }

    private func hideEditAndDelete() {
        editButton.isHidden = true
        deleteButton.isHidden = true
    }

    private func showEditAndDelete() {
        editButton.isHidden = false
        deleteButton.isHidden = false
    }
}

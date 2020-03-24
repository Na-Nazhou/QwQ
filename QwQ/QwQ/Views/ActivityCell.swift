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
    @IBOutlet private var timeLabel: UILabel!
    @IBOutlet private var queueBookImageView: UIImageView!
    
    @IBAction private func handleDelete(_ sender: Any) {
        deleteAction?()
    }

    @IBAction private func handleEdit(_ sender: Any) {
        editAction?()
    }

    // TODO: take in record protocol instead
    func setUpView(record: Record) {
        nameLabel.text = record.restaurant.name
        descriptionLabel.text = "\(record.groupSize) pax"

        if let queueRecord = record as? QueueRecord {
            queueBookImageView.image = UIImage(named: "c-queue-icon")
            // TODO
            timeLabel.text = "Estimated time: 00:00"
            if queueRecord.isWaitingRecord {
                timeLabel.text = "Your table is ready"
                disableEditAndDelete()
            }
        }

        if let bookRecord = record as? BookRecord {
            queueBookImageView.image = UIImage(named: "c-book-icon")
            // TODO
            timeLabel.text = bookRecord.formattedTime
        }

        // Hide edit and delete buttons if it is history record
        if record.isHistoryRecord {
            hideEditAndDelete()
        } else {
            showEditAndDelete()
        }
    }

    private func disableEditAndDelete() {
        editButton.isEnabled = false
        editButton.alpha = 0.5
        deleteButton.isEnabled = false
        deleteButton.alpha = 0.5
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

//
//  QueueRecordCell.swift
//  QwQ-restaurant
//
//  Created by Tan Su Yee on 15/3/20.
//

import UIKit

class QueueRecordCell: UICollectionViewCell {
    var admitAction: (() -> Void)?
    var removeAction: (() -> Void)?
    
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!
    @IBOutlet private var statusLabel: UILabel!
    @IBOutlet private var queueBookImageView: UIImageView!
    @IBOutlet private var estimatedTimeLabel: UILabel!
    
    @IBAction private func handleAdmit(_ sender: UIButton) {
        admitAction?()
    }
    
    @IBAction private func handleRemove(_ sender: UIButton) {
        removeAction?()
    }

    func setUpView(record: Record) {
        nameLabel.text = record.customer.name
        descriptionLabel.text = "\(record.groupSize) pax"

        if let queueRecord = record as? QueueRecord {
            queueBookImageView.image = UIImage(named: "c-queue-icon")
            statusLabel.text = "Queued at: \(queueRecord.startTime.toString())"

            if queueRecord.isWaitingRecord {
                assert(queueRecord.admitTime != nil, "Admit time cannot be nil")
                statusLabel.text = "Admitted at: \(queueRecord.admitTime!.toString())"
            }
        }

        if let bookRecord = record as? BookRecord {
            queueBookImageView.image = UIImage(named: "c-book-icon")
            statusLabel.text = "Booking time: \(bookRecord.formattedTime)"
        }

        // Hide edit and delete buttons if it is history record
        if record.isHistoryRecord {
            if let serveTime = record.serveTime {
                statusLabel.text = "Served at: \(serveTime.toString())"
            }

            if let rejectTime = record.rejectTime {
                statusLabel.text = "Rejected at: \(rejectTime.toString())"
            }
        }
    }
}

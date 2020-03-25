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

        switch record.status {
        case .pendingAdmission:
            if let queueRecord = record as? QueueRecord {
                statusLabel.text = "Queued at: \(queueRecord.startTime.toString())"
            }
            if let bookRecord = record as? BookRecord {
                statusLabel.text = "Time: \(bookRecord.time.toString())"
            }
        case .admitted:
            statusLabel.text = "Admitted at: \(record.admitTime!.toString())"
        case .served:
            statusLabel.text = "Served at: \(record.serveTime!.toString())"
        case .rejected:
            statusLabel.text = "Rejected at: \(record.rejectTime!.toString())"
        default:
            assert(false)
        }

        if record as? QueueRecord != nil {
            queueBookImageView.image = UIImage(named: "c-queue-icon")
        }

        if record as? BookRecord != nil {
            queueBookImageView.image = UIImage(named: "c-book-icon")
        }
    }
}

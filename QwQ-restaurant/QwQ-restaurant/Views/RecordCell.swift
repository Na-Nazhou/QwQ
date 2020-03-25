//
//  QueueRecordCell.swift
//  QwQ-restaurant
//
//  Created by Tan Su Yee on 15/3/20.
//

import UIKit

class RecordCell: UICollectionViewCell {
    var admitAction: (() -> Void)?
    var rejectAction: (() -> Void)?
    var serveAction: (() -> Void)?
    
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!
    @IBOutlet private var statusLabel: UILabel!
    @IBOutlet private var queueBookImageView: UIImageView!
    @IBOutlet private var timeLabel: UILabel!
    
    @IBOutlet private var rightButton: UIButton!
    @IBOutlet private var leftButton: UIButton!

    @IBAction private func handleAdmit(_ sender: UIButton) {
        admitAction?()
    }

    @IBAction private func handleServe(_ sender: UIButton) {
        serveAction?()
    }
    
    @IBAction private func handleReject(_ sender: UIButton) {
        rejectAction?()
    }

    func setUpView(record: Record) {
        nameLabel.text = record.customer.name
        descriptionLabel.text = "\(record.groupSize) pax"
        setUpAdmitButton()
        setUpRejectButton()

        switch record.status {
        case .pendingAdmission:
            if let queueRecord = record as? QueueRecord {
                statusLabel.text = "Queued at: \(queueRecord.startTime.toString())"
            }
            if let bookRecord = record as? BookRecord {
                statusLabel.text = "Time: \(bookRecord.time.toString())"
            }
            disableReject()
            showButtons()
        case .admitted:
            statusLabel.text = "Admitted at: \(record.admitTime!.toString())"
            enableReject()
            showButtons()
            setUpServeButton()
        case .served:
            statusLabel.text = "Served at: \(record.serveTime!.toString())"
            hideButtons()
        case .rejected:
            statusLabel.text = "Rejected at: \(record.rejectTime!.toString())"
            hideButtons()
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

    private func disableReject() {
        rightButton.isEnabled = false
        rightButton.alpha = 0.5
    }

    private func enableReject() {
        rightButton.isEnabled = true
        rightButton.alpha = 1
    }

    private func hideButtons() {
        leftButton.isHidden = true
        rightButton.isHidden = true
    }

    private func showButtons() {
        leftButton.isHidden = false
        rightButton.isHidden = false
    }

    private func setUpAdmitButton() {
        leftButton.setTitle("ADMIT", for: .normal)
    }

    private func setUpServeButton() {
        leftButton.setTitle("SERVE", for: .normal)
    }

    private func setUpRejectButton() {
        rightButton.setTitle("REJECT", for: .normal)
    }
}

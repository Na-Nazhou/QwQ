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
        setUpRejectButton()

        switch record.status {
        case .pendingAdmission:
            if let queueRecord = record as? QueueRecord {
                statusLabel.text = "Queued at: \(queueRecord.startTime.toString())"
                timeLabel.text = "00:00"
            }
            if let bookRecord = record as? BookRecord {
                statusLabel.text = "Reservation Time: \(bookRecord.time.toString())"
                timeLabel.text = bookRecord.time.getFormattedTime()
            }
            timeLabel.textColor = .systemGreen
            setUpAdmitButton()
            disableReject()
            showButtons()
        case .admitted:
            statusLabel.text = "Admitted at: \(record.admitTime!.toString())"
            if let bookRecord = record as? BookRecord {
                timeLabel.text = bookRecord.time.getFormattedTime()
            } else {
                timeLabel.text = record.admitTime!.getFormattedTime()
            }
            timeLabel.textColor = .systemGreen
            enableReject()
            showButtons()
            setUpServeButton()
        case .served:
            statusLabel.text = "Served at: \(record.serveTime!.toString())"
            timeLabel.text = record.serveTime!.getFormattedTime()
            timeLabel.textColor = .systemGreen
            hideButtons()
        case .rejected:
            statusLabel.text = "Rejected at: \(record.rejectTime!.toString())"
            timeLabel.text = record.rejectTime!.getFormattedTime()
            timeLabel.textColor = .systemGray
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
        leftButton.addTarget(self, action: #selector(handleAdmit), for: .touchUpInside)
    }

    private func setUpServeButton() {
        leftButton.setTitle("SERVE", for: .normal)
        leftButton.removeTarget(self, action: #selector(handleAdmit), for: .touchUpInside)
        leftButton.addTarget(self, action: #selector(handleServe), for: .touchUpInside)
    }

    private func setUpRejectButton() {
        rightButton.setTitle("REJECT", for: .normal)
        rightButton.addTarget(self, action: #selector(handleReject), for: .touchUpInside)
    }
}

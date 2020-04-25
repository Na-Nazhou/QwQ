//
//  QueueRecordCell.swift
//  QwQ-restaurant
//
//  Created by Tan Su Yee on 15/3/20.
//

import UIKit

class RecordCell: UICollectionViewCell {

    typealias CustomerStorage = FIRCustomerStorage

    var admitAction: (() -> Void)?
    var rejectAction: (() -> Void)?
    var serveAction: (() -> Void)?

    // MARK: View properties
    @IBOutlet private var nameLabel: UILabel!
    @IBOutlet private var descriptionLabel: UILabel!
    @IBOutlet private var statusLabel: UILabel!
    @IBOutlet private var queueBookImageView: UIImageView!
    @IBOutlet private var timeLabel: UILabel!
    @IBOutlet private var profileImageView: ProfileImageView!
    
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
        CustomerStorage.getCustomerProfilePic(uid: record.customer.uid, imageView: profileImageView)

        setUpRecordImage(record: record)
        setUpActionButtons()

        switch record.status {
        case .pendingAdmission:
            setUpPendingAdmissionRecord(record: record)
        case .missedAndPending:
            setUpMissedAndPendingAdmissionRecord(record: record)
        case .admitted:
            setUpAdmittedRecord(record: record)
        case .confirmedAdmission:
            setUpConfirmedRecord(record: record)
        default:
            setUpHistoryRecord(record: record)
        }

        checkPermissions(for: record)
    }

    private func setUpActionButtons() {
        showActionButtons()
        enableLeftButton()
        enableRightButton()
        setUpRejectButton()
    }

    private func checkPermissions(for record: Record) {
        if record as? QueueRecord != nil {
            if !PermissionsManager.checkPermissions(Permission.acceptQueue) {
                disableLeftButton()
            }
            if !PermissionsManager.checkPermissions(Permission.rejectQueue) {
                disableRightButton()
            }
        }
        if record as? BookRecord != nil {
            if !PermissionsManager.checkPermissions(Permission.acceptBooking) {
                disableLeftButton()
            }
            if !PermissionsManager.checkPermissions(Permission.rejectBooking) {
                disableRightButton()
            }
        }
    }

    private func setUpRecordImage(record: Record) {
        if record as? QueueRecord != nil {
            queueBookImageView.image = UIImage(named: "c-queue-icon")
        }

        if record as? BookRecord != nil {
            queueBookImageView.image = UIImage(named: "c-book-icon")
        }
    }

    private func setUpPendingAdmissionRecord(record: Record) {
        if let queueRecord = record as? QueueRecord {
            statusLabel.text = "Queued at: \(queueRecord.startTime.toString())"
            if let estimatedAdmitime = queueRecord.estimatedAdmitTime {
                timeLabel.text = estimatedAdmitime.getFormattedTime()
            } else {
                timeLabel.text = queueRecord.startTime.getFormattedTime()
            }

            //disableRightButton()
        }
        if let bookRecord = record as? BookRecord {
            statusLabel.text = "Reservation Time: \(bookRecord.time.toString())"
            timeLabel.text = bookRecord.time.getFormattedTime()
        }
        timeLabel.textColor = .systemGreen
        setUpAdmitButton()
    }

    private func setUpMissedAndPendingAdmissionRecord(record: Record) {
        if let queueRecord = record as? QueueRecord {
            statusLabel.text = "Queued at: \(queueRecord.startTime.toString())"
            if let estimatedAdmitime = queueRecord.estimatedAdmitTime {
                timeLabel.text =
                    (estimatedAdmitime.addingTimeInterval(60 * Constants.inactivateAdmitAfterMissTimeInMins))
                        .getFormattedTime()
            } else {
                timeLabel.text =
                    (queueRecord.startTime.addingTimeInterval(60 * Constants.inactivateAdmitAfterMissTimeInMins))
                        .getFormattedTime()
            }

            disableAdmitButtonIfJustMissed(record: queueRecord)
        }
        assert(record as? BookRecord == nil)
        timeLabel.textColor = .systemGreen
        setUpAdmitButton()
    }

    private func setUpHistoryRecord(record: Record) {
        switch record.status {
        case .served:
            statusLabel.text = "Served at: \(record.serveTime!.toString())"
            timeLabel.text = record.serveTime!.getFormattedTime()
            timeLabel.textColor = .systemGreen
        case .rejected:
            statusLabel.text = "Rejected at: \(record.rejectTime!.toString())"
            timeLabel.text = record.rejectTime!.getFormattedTime()
            timeLabel.textColor = .systemGray
        case .withdrawn:
            statusLabel.text = "Withdrawn at: \(record.withdrawTime!.toString())"
            timeLabel.text = record.withdrawTime!.getFormattedTime()
            timeLabel.textColor = .systemGray
        default:
            assert(false)
        }
        hideActionButtons()
    }

    private func setUpAdmittedRecord(record: Record) {
        statusLabel.text = "Admitted at: \(record.admitTime!.toString())"
        if let bookRecord = record as? BookRecord {
            timeLabel.text = bookRecord.time.getFormattedTime()
            disableRightButton()
        } else {
            timeLabel.text = record.admitTime!.getFormattedTime()
        }
        timeLabel.textColor = .systemGray
        setUpServeButton()
        disableLeftButton()
    }

    private func setUpConfirmedRecord(record: Record) {
        statusLabel.text = "Confirmed at: \(record.confirmAdmissionTime!.toString())"
        timeLabel.text = record.confirmAdmissionTime!.getFormattedTime()
        if let bookRecord = record as? BookRecord {
            timeLabel.text = bookRecord.time.getFormattedTime()
            disableRightButton()
        }
        // For queue record should show a timer instead
        // show grey if exceed time limit
        timeLabel.textColor = .systemGreen
        setUpServeButton()
    }

    private func disableRightButton() {
        rightButton.disable()
    }

    private func enableRightButton() {
        rightButton.enable()
    }

    private func disableLeftButton() {
        leftButton.disable()
    }

    private func enableLeftButton() {
        leftButton.enable()
    }

    private func hideActionButtons() {
        leftButton.isHidden = true
        rightButton.isHidden = true
    }

    private func showActionButtons() {
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

    private func disableAdmitButtonIfJustMissed(record: QueueRecord) {
        assert(record.missTime != nil)
        let now = Date()
        let enableTime = record.missTime!.addingTimeInterval(60 * Constants.inactivateAdmitAfterMissTimeInMins)
        guard now < enableTime else {
            return
        }
        disableLeftButton()
        //add timer to enable.
        let enableTimer = Timer(
            fire: enableTime,
            interval: 1, repeats: false) { _ in
                self.enableLeftButton()
        }
        RunLoop.main.add(enableTimer, forMode: .common)
    }
}

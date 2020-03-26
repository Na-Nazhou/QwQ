//
//  QueueViewController.swift
//  QwQ-restaurant
//
//  Created by Tan Su Yee on 15/3/20.
//

import UIKit

class QueueRecordViewController: UIViewController, RecordViewController {
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var contactLabel: UILabel!
    @IBOutlet var groupSizeLabel: UILabel!
    @IBOutlet var babyChairQuantityLabel: UILabel!
    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var wheelchairFriendlySwitch: UISwitch!
    @IBOutlet var actionButton: UIButton!
    var record: Record?

    var spinner: UIView?
    
    @IBAction private func handleAdmit(_ sender: Any) {
        guard let queueRecord = record as? QueueRecord else {
            return
        }
        self.spinner = self.showSpinner(onView: self.view)
        RestaurantQueueLogicManager.shared().admitCustomer(record: queueRecord, completion: {
            self.didUpdateQueueRecord()
        })
    }

    @IBAction private func handleServe(_ sender: Any) {
        guard let queueRecord = record as? QueueRecord else {
            return
        }
        self.spinner = self.showSpinner(onView: self.view)
        RestaurantQueueLogicManager.shared().serveCustomer(record: queueRecord, completion: {
            self.didUpdateQueueRecord()
        })

    }

    // TODO
    @IBAction private func handleReject(_ sender: Any) {
        guard let queueRecord = record as? QueueRecord else {
            return
        }
        self.spinner = self.showSpinner(onView: self.view)
        RestaurantQueueLogicManager.shared().rejectCustomer(record: queueRecord, completion: {
            self.didUpdateQueueRecord()
        })

    }

    func didUpdateQueueRecord() {
        removeSpinner(spinner)
        handleBack()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpViews()
    }

    @IBAction private func handleBack(_ sender: Any) {
        handleBack()
    }

    private func setUpViews() {
        guard let queueRecord = record as? QueueRecord else {
            return
        }
        setUpRecordView()

        if queueRecord.isPendingAdmission {
            setUpAdmitButton()
        }

        if queueRecord.isAdmitted {
            setUpServeButton()
        }

        if queueRecord.isHistoryRecord {
            hideActionButton()
        }
    }

    private func setUpAdmitButton() {
        actionButton.setTitle("ADMIT", for: .normal)
        actionButton.addTarget(self, action: #selector(handleAdmit), for: .touchUpInside)
    }

    private func setUpServeButton() {
        actionButton.setTitle("SERVE", for: .normal)
        actionButton.addTarget(self, action: #selector(handleServe), for: .touchUpInside)
    }

    // TODO
    private func setUpRejectButton() {
        actionButton.setTitle("REJECT", for: .normal)
        actionButton.addTarget(self, action: #selector(handleReject), for: .touchUpInside)
    }

    private func hideActionButton() {
        actionButton.isHidden = true
    }
}

//
//  ActivitiesViewController.swift
//  QwQ
//
//  Created by Tan Su Yee on 18/3/20.
//

import UIKit

class ActivitiesViewController: UIViewController, ActivitiesDelegate {

    @IBOutlet private var activeHistoryControl: SegmentedControl!
    @IBOutlet private var activitiesCollectionView: UICollectionView!

    var spinner: UIView?

    let queueLogicManager = CustomerQueueLogicManager()
    let bookingLogicManager = CustomerBookingLogicManager()

    var records: [Record] {
        if isActive {
            return activeRecords
        } else {
            return historyRecords
        }
    }

    var selectedIndex = 0

    var isActive: Bool {
        selectedIndex == 0
    }

    // TODO: refactor
    var activeRecords: [Record] {
        var records: [Record] = bookingLogicManager.activeBookRecords
        records += queueLogicManager.currentQueueRecords
        return records.sorted(by: { record1, record2 in
            let time1: Date
            let time2: Date
            if let queueRecord1 = record1 as? QueueRecord {
                time1 = queueRecord1.startTime
            } else {
                time1 = (record1 as? BookRecord)!.time
            }
            if let queueRecord2 = record2 as? QueueRecord {
                time2 = queueRecord2.startTime
            } else {
                time2 = (record2 as? BookRecord)!.time
            }
            return time1 > time2
        })
    }

    var historyRecords: [Record] {
        let bookRecords = bookingLogicManager.pastBookRecords
        let queueRecords = queueLogicManager.pastQueueRecords
        return (bookRecords + queueRecords).sorted(by: { record1, record2 in
            let time1: Date
            let time2: Date
            if record1.isServed {
                time1 = record1.serveTime!
            } else if record1.isRejected {
                time1 = record1.rejectTime!
            } else {
                time1 = record1.withdrawTime!
            }
            if record2.isServed {
                time2 = record2.serveTime!
            } else if record2.isRejected {
                time2 = record2.rejectTime!
            } else {
                time2 = record2.withdrawTime!
            }
            return time1 > time2
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activitiesCollectionView.dataSource = self
        activitiesCollectionView.delegate = self

        queueLogicManager.activitiesDelegate = self
        bookingLogicManager.activitiesDelegate = self

        setUpSegmentedControl()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        activitiesCollectionView.reloadData()
    }

    private func setUpSegmentedControl() {
        activeHistoryControl.addTarget(self, action: #selector(onTapSegButton), for: .valueChanged)
    }

    @IBAction private func onTapSegButton(_ sender: SegmentedControl) {
        selectedIndex = sender.selectedIndex
        activitiesCollectionView.reloadData()
    }

    func didUpdateHistoryRecords() {
        if isActive {
            return
        }
        activitiesCollectionView.reloadData()
    }
    
    func didUpdateActiveRecords() {
        if isActive {
            activitiesCollectionView.reloadData()
        }
    }

    func didWithdrawRecord() {
        removeSpinner(spinner)
        showMessage(
            title: Constants.successTitle,
            message: Constants.recordWithdrawSuccessMessage,
            buttonText: Constants.okayTitle,
            buttonAction: {_ in
                self.handleBack()
                self.activitiesCollectionView.reloadData()
            })
    }

    func didConfirmAdmissionOfRecord() {
        removeSpinner(spinner)
        showMessage(
            title: Constants.successTitle,
            message: Constants.recordConfirmSuccessMessage,
            buttonText: Constants.okayTitle,
            buttonAction: {_ in
                self.handleBack()
                self.activitiesCollectionView.reloadData()
            })
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case Constants.queueSelectedSegue:
            if let queueRecord = sender as? QueueRecord,
                let queueRecordViewController = segue.destination as? QueueRecordViewController {
                    queueRecordViewController.record = queueRecord
            }
        case Constants.bookSelectedSegue:
            if let bookRecord = sender as? BookRecord,
                let bookRecordViewController = segue.destination as? BookRecordViewController {
                    bookRecordViewController.record = bookRecord
            }
        case Constants.editQueueSelectedSegue:
            if let queueRecord = sender as? QueueRecord,
                let editQueueViewController = segue.destination as? EditQueueViewController {
                    editQueueViewController.record = queueRecord
                editQueueViewController.queueLogicManager = queueLogicManager
        }
        case Constants.editBookSelectedSegue:
            if let bookRecord = sender as? BookRecord,
                let editBookingViewController = segue.destination as? EditBookingViewController {
                    editBookingViewController.record = bookRecord
                editBookingViewController.bookingLogicManager = bookingLogicManager
            }
        default:
            return
        }
    }
}

extension ActivitiesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        records.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView
            .dequeueReusableCell(withReuseIdentifier: Constants.activitiesReuseIdentifier,
                                 for: indexPath)
        
        guard let activityCell = cell as? ActivityCell else {
            return cell
        }
        
        let record = records[indexPath.row]
        activityCell.setUpView(record: record)
        
        if let queueRecord = record as? QueueRecord {
             if record.isPendingAdmission {
                activityCell.editAction = {
                    self.performSegue(withIdentifier: Constants.editQueueSelectedSegue, sender: queueRecord)
                }
            } else if record.isAdmitted {
                activityCell.confirmAction = {
                    self.spinner = self.showSpinner(onView: self.view)
                    self.queueLogicManager.confirmAdmissionOfQueueRecord(queueRecord)
                }
            }
            activityCell.deleteAction = {
                self.spinner = self.showSpinner(onView: self.view)
                self.queueLogicManager.withdrawQueueRecord(queueRecord)
            }

        }

        if let bookRecord = record as? BookRecord {
            activityCell.editAction = {
                if record.isPendingAdmission {
                    self.performSegue(withIdentifier: Constants.editBookSelectedSegue, sender: bookRecord)
                }
            }
            activityCell.deleteAction = {
                self.spinner = self.showSpinner(onView: self.view)
                self.bookingLogicManager.withdrawBookRecord(bookRecord)
            }
        }

        return activityCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let record = records[indexPath.row]
        if let queueRecord = record as? QueueRecord {
            performSegue(withIdentifier: Constants.queueSelectedSegue, sender: queueRecord)
        }
        if let bookRecord = record as? BookRecord {
            performSegue(withIdentifier: Constants.bookSelectedSegue, sender: bookRecord)
        }
    }
}

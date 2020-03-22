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

    var records: [Record] {
        if isActive {
            return activeRecords
        } else {
            return historyRecords
        }
    }

    var isActive = true

    // TODO: refactor
    var activeRecords: [Record] {
        var records: [Record] = CustomerBookingLogicManager.shared().activeBookRecords
        if let activeQueueRecord = CustomerQueueLogicManager.shared().currentQueueRecord {
            records.append(activeQueueRecord)
        }
        return records
    }

    var historyRecords: [Record] {
        CustomerQueueLogicManager.shared().pastQueueRecords
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activitiesCollectionView.dataSource = self
        activitiesCollectionView.delegate = self

        CustomerQueueLogicManager.shared().activitiesDelegate = self
        CustomerBookingLogicManager.shared().activitiesDelegate = self

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
        switch sender.selectedIndex {
        case 0:
            isActive = true
        case 1:
            CustomerQueueLogicManager.shared().fetchQueueHistory()
            isActive = false
        default:
            return
        }
        activitiesCollectionView.reloadData()
    }

    func didLoadNewHistoryRecords() {
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

    func didDeleteQueueRecord() {
        removeSpinner(spinner)
        showMessage(
            title: Constants.successTitle,
            message: Constants.queueRecordDeleteSuccessMessage,
            buttonText: Constants.okayTitle,
            buttonAction: {_ in
                self.navigationController?.popViewController(animated: true)
                self.activitiesCollectionView.reloadData()
            })
    }

    func didDeleteBookRecord() {
        removeSpinner(spinner)
        showMessage(
            title: Constants.successTitle,
            message: Constants.bookRecordDeleteSuccessMessage,
            buttonText: Constants.okayTitle,
            buttonAction: {_ in
                self.navigationController?.popViewController(animated: true)
                self.activitiesCollectionView.reloadData()
            })
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
            activityCell.editAction = {
                self.performSegue(withIdentifier: Constants.editQueueSelectedSegue, sender: queueRecord)
            }
            activityCell.deleteAction = {
                self.spinner = self.showSpinner(onView: self.view)
                CustomerQueueLogicManager.shared().deleteQueueRecord(queueRecord)
            }
        }

        if let bookRecord = record as? BookRecord {
            activityCell.editAction = {
                self.performSegue(withIdentifier: Constants.editBookSelectedSegue, sender: bookRecord)
            }
            activityCell.deleteAction = {
                 self.spinner = self.showSpinner(onView: self.view)
                CustomerBookingLogicManager.shared().deleteBookRecord(bookRecord)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case Constants.queueSelectedSegue:
            if let queueRecord = sender as? QueueRecord,
                let queueRecordViewController = segue.destination as? QueueRecordViewController {
                    queueRecordViewController.queueRecord = queueRecord
            }
        case Constants.bookSelectedSegue:
            if let bookRecord = sender as? BookRecord,
                let bookRecordViewController = segue.destination as? BookRecordViewController {
                    bookRecordViewController.bookRecord = bookRecord
            }
        case Constants.editBookSelectedSegue:
            // TODO: fix
            if let bookRecord = sender as? BookRecord,
                let editBookingViewController = segue.destination as? EditBookingViewController {
                    editBookingViewController.bookRecord = bookRecord
            }
        default:
            // No need to to anything for editQueueSelectedSegue
            return
        }
    }
}

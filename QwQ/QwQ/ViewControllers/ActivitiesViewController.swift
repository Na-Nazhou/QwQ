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

    var queueRecords: [QueueRecord] {
        if isActive {
            return activeRecords
        } else {
            return historyRecords
        }
    }

    var isActive = true

    var activeRecords: [QueueRecord] {
        if let activeRecord = CustomerQueueLogicManager.shared().currentQueueRecord {
            return [activeRecord]
        } else {
            return []
        }
    }

    var historyRecords: [QueueRecord] {
        CustomerQueueLogicManager.shared().queueHistory
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activitiesCollectionView.dataSource = self
        activitiesCollectionView.delegate = self

        CustomerQueueLogicManager.shared().activitiesDelegate = self

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

    func didDeleteQueueRecord() {
        showMessage(
            title: Constants.successfulUpdateTitle,
            message: Constants.successQueueRecordDeleteMessage,
            buttonText: Constants.okayTitle,
            buttonAction: {_ in
                self.navigationController?.popViewController(animated: true)
                self.activitiesCollectionView.reloadData()
            })
    }
}

extension ActivitiesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        queueRecords.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView
            .dequeueReusableCell(withReuseIdentifier: Constants.activitiesReuseIdentifier,
                                 for: indexPath)
        
        guard let activityCell = cell as? ActivityCell else {
            return cell
        }
        
        let queueRecord = queueRecords[indexPath.row]
        activityCell.setUpView(queueRecord: queueRecord)
        activityCell.editAction = {
            self.performSegue(withIdentifier: Constants.editQueueSelectedSegue, sender: queueRecord)
        }
        activityCell.deleteAction = {
            CustomerQueueLogicManager.shared().deleteQueueRecord()
        }
        
        return activityCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: Constants.queueSelectedSegue, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case Constants.queueSelectedSegue:
            if let indexPaths = self.activitiesCollectionView.indexPathsForSelectedItems {
                let row = indexPaths[0].item
                if let queueRecordViewController = segue.destination as? QueueRecordViewController {
                    queueRecordViewController.queueRecord = queueRecords[row]
                }
            }
        case Constants.bookSelectedSegue:
            if let indexPaths = self.activitiesCollectionView.indexPathsForSelectedItems {
                let row = indexPaths[0].item
                if let bookRecordViewController = segue.destination as? BookRecordViewController {
                    bookRecordViewController.bookRecord = queueRecords[row]
                }
            }
        case Constants.editBookSelectedSegue:
            // TODO: fix
            if let bookRecord = sender as? QueueRecord,
                let editBookingViewController = segue.destination as? EditBookingViewController {
                    editBookingViewController.bookRecord = bookRecord
            }
        default:
            // No need to to anything for editQueueSelectedSegue
            return
        }
    }
}

extension ActivitiesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: self.view.frame.width, height: self.view.frame.height / 5)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        Constants.activitiesSectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
}

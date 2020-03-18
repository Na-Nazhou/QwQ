//
//  ActivitiesViewController.swift
//  QwQ
//
//  Created by Tan Su Yee on 18/3/20.
//

import UIKit

class ActivitiesViewController: UIViewController, ActivitiesDelegate {
    @IBOutlet private var activeHistoryControl: UISegmentedControl!
    @IBOutlet private var activitiesCollectionView: UICollectionView!

    var queueRecords = [QueueRecord]()

    var activeRecord: QueueRecord? {
        CustomerQueueLogicManager.shared().currentQueueRecord
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

    private func setUpSegmentedControl() {
        if let activeRecord = activeRecord {
            queueRecords = [activeRecord]
        }
        activitiesCollectionView.reloadData()
        activeHistoryControl.addTarget(self, action: #selector(onTapSegButton), for: .valueChanged)
    }

    @IBAction private func onTapSegButton(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            if let activeRecord = activeRecord {
                queueRecords = [activeRecord]
            } else {
                queueRecords = []
            }
        case 1:
            CustomerQueueLogicManager.shared().fetchQueueHistory()
            queueRecords = historyRecords
        default:
            return
        }
        activitiesCollectionView.reloadData()
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

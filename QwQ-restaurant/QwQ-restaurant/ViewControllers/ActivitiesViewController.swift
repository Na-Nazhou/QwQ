//
//  ActivitiesViewController.swift
//  QwQ-restaurant
//
//  Created by Tan Su Yee on 14/3/20.
//  Copyright © 2020 Appfish. All rights reserved.
//

import UIKit
import Foundation

class ActivitiesViewController: UIViewController {
    // MARK: View properties
    @IBOutlet private var searchBarController: UISearchBar!

    @IBOutlet var currentWaitingControl: SegmentedControl!
    @IBOutlet private var recordCollectionView: UICollectionView!

    @IBOutlet private var openCloseButton: UIButton!

    var spinner: UIView?
    
    // MARK: Model properties
    let recordLogicManager = RestaurantRecordLogicManager()

    var filtered: [Record] = []

    var records: [Record] {
        switch selectedIndex {
        case 0:
            return currentRecords
        case 1:
            return waitingRecords
        case 2:
            return historyRecords
        default:
            assert(false)
        }
    }

    var selectedIndex = 0

    // TODO: refactor
    var currentRecords: [Record] {
        recordLogicManager.currentRecords
    }

    var waitingRecords: [Record] {
        recordLogicManager.waitingRecords
    }

    var historyRecords: [Record] {
        recordLogicManager.historyRecords
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
        recordCollectionView.delegate = self
        recordCollectionView.dataSource = self

        recordLogicManager.presentationDelegate = self
        
        filtered = records
        setUpSegmentedControl()

        if recordLogicManager.isQueueOpen {
            openQueue()
        } else {
            closeQueue()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        filtered = records
        recordCollectionView.reloadData()

        super.viewWillAppear(animated)
    }

    private func setUpSegmentedControl() {
        currentWaitingControl.items = Constants.segmentedControlActivitiesTitles
        currentWaitingControl.addTarget(self, action: #selector(onTapSegButton), for: .valueChanged)
    }

    @IBAction private func onTapSegButton(_ sender: SegmentedControl) {
        selectedIndex = sender.selectedIndex
        filtered = records
        recordCollectionView.reloadData()
    }

    @IBAction private func handleOpenClose(_ sender: UIButton) {
        guard let title = sender.currentTitle?.uppercased() else {
            assert(false, "open close button title should not be nil")
            return
        }
        switch title {
        case Constants.buttonTextToOpenQueue:
            openQueue()
            recordLogicManager.openQueue()
        case Constants.buttonTextToCloseQueue:
            closeQueue()
            recordLogicManager.closeQueue()
        default:
            assert(false, "open close button title should be either open or close.")
        }
    }

    private func openQueue() {
        openCloseButton.setTitle(Constants.buttonTextToCloseQueue, for: .normal)
        openCloseButton.backgroundColor = .systemRed
    }

    private func closeQueue() {
        openCloseButton.setTitle(Constants.buttonTextToOpenQueue, for: .normal)
        openCloseButton.backgroundColor = .systemGreen
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case Constants.queueRecordSelectedSegue:
        if let queueRecord = sender as? QueueRecord,
            let queueRecordViewController = segue.destination as? QueueRecordViewController {
            queueRecordViewController.record = queueRecord
            queueRecordViewController.recordLogicManager = recordLogicManager
        }
        case Constants.bookRecordSelectedSegue:
        if let bookRecord = sender as? BookRecord,
            let bookRecordViewController = segue.destination as? BookRecordViewController {
                bookRecordViewController.record = bookRecord
            bookRecordViewController.recordLogicManager = recordLogicManager
        }
        default:
            return
        }
    }
}

extension ActivitiesViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if !(searchBar.text?.isEmpty)! {
            self.recordCollectionView?.reloadData()
        }
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filtered = searchText.isEmpty ? records : records.filter { (item: Record) -> Bool in
            item.customer.name.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
    }
}

extension ActivitiesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {

        if kind == UICollectionView.elementKindSectionHeader {
            let headerView: UICollectionReusableView = collectionView
                .dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                  withReuseIdentifier: Constants.collectionViewHeaderReuseIdentifier,
                                                  for: indexPath)

             return headerView
         }

         return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        filtered.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView
            .dequeueReusableCell(withReuseIdentifier: Constants.queueRecordReuseIdentifier,
                                 for: indexPath)
        
        guard let recordCell = cell as? RecordCell else {
            return cell
        }

        let record = filtered[indexPath.row]
        recordCell.setUpView(record: record)

        if let queueRecord = record as? QueueRecord {
            recordCell.admitAction = {
                self.recordLogicManager.admitCustomer(record: queueRecord,
                                                      completion: self.didUpdateRecord)
            }

            if queueRecord.isAdmitted {
                recordCell.rejectAction = {
                    self.recordLogicManager.rejectCustomer(record: queueRecord,
                                                           completion: self.didUpdateRecord)
                }

                recordCell.serveAction = {
                    self.recordLogicManager.serveCustomer(record: queueRecord,
                                                          completion: self.didUpdateRecord)
                }
            }
        }

        if let bookRecord = record as? BookRecord {
            recordCell.admitAction = {
                self.recordLogicManager.admitCustomer(record: bookRecord,
                                                      completion: self.didUpdateRecord)
            }

            if bookRecord.isAdmitted {
                recordCell.rejectAction = {
                    self.recordLogicManager.rejectCustomer(record: bookRecord,
                                                           completion: self.didUpdateRecord)
                }

                recordCell.serveAction = {
                    self.recordLogicManager.serveCustomer(record: bookRecord,
                                                          completion: self.didUpdateRecord)
                }
            }
        }

        return recordCell
    }

    func didUpdateRecord() {
        filtered = records
        recordCollectionView.reloadData()
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let record = records[indexPath.row]
        if let queueRecord = record as? QueueRecord {
            performSegue(withIdentifier: Constants.queueRecordSelectedSegue, sender: queueRecord)
        }
        if let bookRecord = record as? BookRecord {
            performSegue(withIdentifier: Constants.bookRecordSelectedSegue, sender: bookRecord)
        }
    }
}

extension ActivitiesViewController: RestaurantQueueLogicPresentationDelegate {

    func restaurantDidChangeQueueStatus(toIsOpen: Bool) {
        if toIsOpen {
            openQueue()
        } else {
            closeQueue()
        }
    }
    func didUpdateCurrentList() {
        if selectedIndex == 0 {
            self.filtered = self.records
            recordCollectionView.reloadData()
        }
    }

    func didUpdateWaitingList() {
        if selectedIndex == 1 {
            self.filtered = self.records
            recordCollectionView.reloadData()
        }
    }

    func didUpdateHistoryList() {
        if selectedIndex == 2 {
            self.filtered = self.records
            recordCollectionView.reloadData()
        }
    }
}

extension ActivitiesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
    
        CGSize(width: self.view.frame.width * 0.9, height: Constants.activityCellHeight)
    }
}

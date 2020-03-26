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

    @IBOutlet private var searchBarController: UISearchBar!

    @IBOutlet var currentWaitingControl: SegmentedControl!
    @IBOutlet private var recordCollectionView: UICollectionView!

    @IBOutlet private var openCloseButton: UIButton!

    var spinner: UIView?

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
        // TODO: get both queue records and booking records
        RestaurantQueueLogicManager.shared().currentRecords
    }

    var waitingRecords: [Record] {
        RestaurantQueueLogicManager.shared().waitingRecords
    }

    var historyRecords: [Record] {
        RestaurantQueueLogicManager.shared().historyRecords
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
        recordCollectionView.delegate = self
        recordCollectionView.dataSource = self

        RestaurantQueueLogicManager.shared().presentationDelegate = self
        // TODO: set delegate for BookingLogicManager
        
        filtered = records
        setUpSegmentedControl()

        if RestaurantQueueLogicManager.shared().isQueueOpen {
            openQueue()
        } else {
            closeQueue()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        filtered = records
        recordCollectionView.reloadData()
    }

    private func setUpSegmentedControl() {
        currentWaitingControl.addTarget(self, action: #selector(onTapSegButton), for: .valueChanged)
    }

    @IBAction private func onTapSegButton(_ sender: SegmentedControl) {
        selectedIndex = sender.selectedIndex
        filtered = records
        recordCollectionView.reloadData()
        switch sender.selectedIndex {
        case 0:
            RestaurantQueueLogicManager.shared().fetchCurrent()
        case 1:
            RestaurantQueueLogicManager.shared().fetchWaiting()
        case 2:
            RestaurantQueueLogicManager.shared().fetchHistory()
        default:
            return
        }
    }

    @IBAction private func handleOpenClose(_ sender: UIButton) {
        guard let title = sender.currentTitle?.uppercased() else {
            assert(false, "open close button title should not be nil")
            return
        }
        switch title {
        case Constants.buttonTextToOpenQueue:
            openQueue()
            RestaurantQueueLogicManager.shared().openQueue()
        case Constants.buttonTextToCloseQueue:
            closeQueue()
            RestaurantQueueLogicManager.shared().closeQueue()
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
        }
        case Constants.bookRecordSelectedSegue:
        if let bookRecord = sender as? BookRecord,
            let bookRecordViewController = segue.destination as? BookRecordViewController {
                bookRecordViewController.record = bookRecord
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
                RestaurantQueueLogicManager.shared()
                    .admitCustomer(record: queueRecord,
                                   completion: self.didUpdateQueueRecord)
            }

            if queueRecord.isAdmitted {
                recordCell.rejectAction = {
                    RestaurantQueueLogicManager.shared()
                        .rejectCustomer(record: queueRecord,
                                        completion: self.didUpdateQueueRecord)
                }

                recordCell.serveAction = {
                    RestaurantQueueLogicManager.shared()
                        .serveCustomer(record: queueRecord,
                                       completion: self.didUpdateQueueRecord)
                }
            }
        }

        if let bookRecord = record as? BookRecord {
            recordCell.admitAction = {

            }

            if bookRecord.isAdmitted {
                recordCell.rejectAction = {
                    //TODO allow only at waiting list and link to logic
                }

                recordCell.serveAction = {

                }
            }
        }

        return recordCell
    }

    func didUpdateQueueRecord() {
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

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
    @IBOutlet private var activityControl: SegmentedControl!
    @IBOutlet private var recordCollectionView: UICollectionView!
    @IBOutlet private var openCloseButton: UIButton!
    
    private var spinner: UIView?

    // MARK: Filter
    private var filter: (Record) -> Bool = { _ in true }
    private var filtered: [Record] {
        records.filter(filter)
    }

    // MARK: Segmented control
    private enum SelectedControl: Int {
        case current
        case waiting
        case history
    }
    private var selectedControl: SelectedControl = .current

    // MARK: Logic properties
    private let restaurantLogic: RestaurantLogic = RestaurantLogicManager()
    private let queueLogic: RestaurantQueueLogic = RestaurantQueueLogicManager()
    private let bookingLogic: RestaurantBookingLogic = RestaurantBookingLogicManager()
    private let activityLogic: RestaurantActivityLogic = RestaurantActivityLogicManager()

    // MARK: Model properties
    private var records: [Record] {
        switch selectedControl {
        case .current:
            return activityLogic.currentRecords
        case .waiting:
            return activityLogic.waitingRecords
        case .history:
            return activityLogic.historyRecords
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
        recordCollectionView.delegate = self
        recordCollectionView.dataSource = self

        queueLogic.activitiesDelegate = self
        bookingLogic.activitiesDelegate = self
        restaurantLogic.activitiesDelegate = self

        setUpSegmentedControl()
        setUpQueueStatus()
    }

    private func setUpQueueStatus() {
        if restaurantLogic.isQueueOpen {
            openQueue()
        } else {
            closeQueue()
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        reloadRecords()

        super.viewWillAppear(animated)
    }

    private func setUpSegmentedControl() {
        activityControl.items = Constants.segmentedControlActivitiesTitles
        activityControl.addTarget(self, action: #selector(onTapSegButton), for: .valueChanged)
    }

    @IBAction private func onTapSegButton(_ sender: SegmentedControl) {
        selectedControl = SelectedControl(rawValue: sender.selectedIndex)!
        reloadRecords()
    }

    @IBAction private func handleOpenClose(_ sender: UIButton) {
        guard let title = sender.currentTitle?.uppercased() else {
            assert(false, "open close button title should not be nil")
            return
        }

        spinner = showSpinner(onView: view)
        switch title {
        case Constants.buttonTextToOpenQueue:
            restaurantLogic.openQueue()
        case Constants.buttonTextToCloseQueue:
            restaurantLogic.closeQueue()
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
            queueRecordViewController.queueLogic = queueLogic
        }
        case Constants.bookRecordSelectedSegue:
        if let bookRecord = sender as? BookRecord,
            let bookRecordViewController = segue.destination as? BookRecordViewController {
            bookRecordViewController.record = bookRecord
            bookRecordViewController.bookingLogic = bookingLogic
        }
        default:
            return
        }
    }
}

extension ActivitiesViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        reloadRecords()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filter = { _ in true }
            return
        }

        filter = { (item: Record) -> Bool in
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
                self.queueLogic.admitCustomer(record: queueRecord,
                                              completion: self.didUpdateRecord)
            }

            if queueRecord.isAdmitted || queueRecord.isConfirmedAdmission
            || queueRecord.isPendingAdmission || queueRecord.isMissedAndPending {
                recordCell.rejectAction = {
                    self.queueLogic.rejectCustomer(record: queueRecord,
                                                   completion: self.didUpdateRecord)
                }
            }

            if queueRecord.isConfirmedAdmission || queueRecord.isAdmitted {
                recordCell.serveAction = {
                    self.queueLogic.serveCustomer(record: queueRecord,
                                                  completion: self.didUpdateRecord)
                }
            }
        }

        if let bookRecord = record as? BookRecord {
            recordCell.admitAction = {
                self.bookingLogic.admitCustomer(record: bookRecord,
                                                completion: self.didUpdateRecord)
            }

            if bookRecord.isPendingAdmission {
                recordCell.rejectAction = {
                    self.bookingLogic.rejectCustomer(record: bookRecord,
                                                     completion: self.didUpdateRecord)
                }
            }

            if bookRecord.isConfirmedAdmission {
                recordCell.serveAction = {
                    self.bookingLogic.serveCustomer(record: bookRecord,
                                                    completion: self.didUpdateRecord)
                }
            }
        }

        return recordCell
    }

    private func didUpdateRecord() {
        reloadRecords()
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

extension ActivitiesViewController: ActivitiesDelegate {

    func didUpdateRestaurant() {
        removeSpinner(spinner)
        setUpQueueStatus()
    }

    func didUpdateCurrentList() {
        if selectedControl == .current {
            reloadRecords()
        }
    }

    func didUpdateWaitingList() {
        if selectedControl == .waiting {
            reloadRecords()
        }
    }

    func didUpdateHistoryList() {
        if selectedControl == .history {
            reloadRecords()
        }
    }

    private func reloadRecords() {
        recordCollectionView.reloadData()
    }
}

extension ActivitiesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
    
        CGSize(width: self.view.frame.width * 0.9, height: Constants.activityCellHeight)
    }
}

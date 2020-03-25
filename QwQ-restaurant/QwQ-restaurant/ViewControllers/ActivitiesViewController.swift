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

    var filtered: [Record] = []
    var records: [Record] {
        RestaurantQueueLogicManager.shared().queueRecords
    }
    
    @IBOutlet private var searchBarController: UISearchBar!
    @IBOutlet private var queueRecordCollectionView: UICollectionView!
    
    @IBOutlet private var openCloseButton: UIButton!

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
        queueRecordCollectionView.delegate = self
        queueRecordCollectionView.dataSource = self

        RestaurantQueueLogicManager.shared().presentationDelegate = self
        
        filtered = records

        if RestaurantQueueLogicManager.shared().isQueueOpen {
            openQueue()
        } else {
            closeQueue()
        }
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

    private func openQueue() {
        openCloseButton.setTitle(Constants.buttonTextToCloseQueue, for: .normal)
        openCloseButton.backgroundColor = .systemRed
    }

    private func closeQueue() {
        openCloseButton.setTitle(Constants.buttonTextToOpenQueue, for: .normal)
        openCloseButton.backgroundColor = .systemGreen
    }
    
}

extension ActivitiesViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if !(searchBar.text?.isEmpty)! {
            self.queueRecordCollectionView?.reloadData()
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
        
        guard let queueRecordCell = cell as? QueueRecordCell else {
            return cell
        }
        
        let record = filtered[indexPath.row]
        
        queueRecordCell.setUpView(record: record)
        
        queueRecordCell.admitAction = {
            guard let qRec = record as? QueueRecord else {
                assert(false, "Considering only queue recs and no bookings; TODO")
                return
            }
            RestaurantQueueLogicManager.shared().admitCustomer(record: qRec)
            self.showMessage(title: Constants.admitCustomerTitle,
                             message: Constants.admitCustomerMessage,
                             buttonText: Constants.okayTitle)
        }
        queueRecordCell.removeAction = {
            //TODO allow only at waiting list and link to logic
            self.showMessage(title: Constants.removeCustomerTitle,
                             message: Constants.removeCustomerMessage,
                             buttonText: Constants.okayTitle)
        }
        
        return queueRecordCell
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

    func didAddRecordToQueue(record: QueueRecord) {
        tempUpdateFiltered()
    }

    func didRemoveRecordFromQueue(record: QueueRecord) {
        tempUpdateFiltered()
    }

    func didUpdateRecordInQueue(to new: QueueRecord) {
        tempUpdateFiltered()
    }

    func didAddRecordToWaiting(toWaiting record: QueueRecord) {
        //TODO to waiting list
        tempUpdateFiltered()
    }

    func didRemoveRecordFromWaiting(record: QueueRecord) {
        //TODO
        tempUpdateFiltered()
    }

    private func tempUpdateFiltered() {
        filtered = records
        queueRecordCollectionView.reloadData()
    }
}

extension ActivitiesViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    CGSize(width: self.view.frame.width * 0.9, height: Constants.activityCellHeight)
  }
}

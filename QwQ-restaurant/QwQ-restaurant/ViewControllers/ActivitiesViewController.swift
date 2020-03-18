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
    
    @IBOutlet weak var searchBarController: UISearchBar!
    @IBOutlet weak var queueRecordCollectionView: UICollectionView!
    
    var queueRecords: [QueueRecord] = [QueueRecord(uid: "1",
                                                   restaurant: Restaurant(uid: "3", name: "hottomato", email: "ht@mail.com", contact: "12345678", address: "location", menu: "menu", isOpen: true), customer: Customer(uid: "2", name: "jane", email: "jane@gmail.com", contact: "98273483"),
                                                   groupSize: 4,
                                                   babyChairQuantity: 0, wheelchairFriendly: true,
                                                   startTime: Date()), ]
    
    @IBAction func handleOpenClose(_ sender: Any) { 
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
        queueRecordCollectionView.delegate = self
        queueRecordCollectionView.dataSource = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.queueRecordSelectedSegue {
            if let queueRecordViewController = segue.destination as? QueueRecordViewController {
                if let indexPaths = self.queueRecordCollectionView.indexPathsForSelectedItems {
                    let row = indexPaths[0].item
                    queueRecordViewController.queueRecord = queueRecords[row]
                }
            }
        }
    }
    
}

extension ActivitiesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return queueRecords.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView
            .dequeueReusableCell(withReuseIdentifier: Constants.queueRecordReuseIdentifier,
                                 for: indexPath)
        
        guard let queueRecordCell = cell as? QueueRecordCell else {
            return cell
        }
        
        let queueRecord = queueRecords[indexPath.row]
        
        queueRecordCell.nameLabel.text = queueRecord.customer.name
        queueRecordCell.descriptionLabel.text = "\(queueRecord.groupSize) pax"
        
        queueRecordCell.admitAction = {
            self.showMessage(title: Constants.admitCustomerTitle,
                             message: Constants.admitCustomerMessage,
                             buttonText: Constants.okayTitle,
                             buttonAction: nil)
        }
        queueRecordCell.removeAction = {
            self.showMessage(title: Constants.removeCustomerTitle,
                             message: Constants.removeCustomerMessage,
                             buttonText: Constants.okayTitle,
                             buttonAction: nil)
        }
        
        return queueRecordCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: Constants.queueRecordSelectedSegue, sender: self)
    }
}

extension ActivitiesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width * 0.9, height: self.view.frame.height / 5)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return Constants.queueRecordSectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

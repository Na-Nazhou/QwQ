//
//  ActivitiesViewController.swift
//  QwQ
//
//  Created by Tan Su Yee on 18/3/20.
//

import UIKit

class ActivitiesViewController: UIViewController {
    @IBOutlet weak var activeHistoryControl: UISegmentedControl!
    @IBOutlet weak var activitiesCollectionView: UICollectionView!
    
    var queueRecords: [QueueRecord] = [QueueRecord(restaurant: Restaurant(uid: "1",
                                                                          name: "jane",
                                                                          email: "jane@gmail.com",
                                                                          contact: "9872",
                                                                          address: "1",
                                                                          menu: "1",
                                                                          isOpen: true),
                                                   customer: Customer(uid: "2", name: "name", email: "name@", contact: "9827"),
                                                   groupSize: 2,
                                                   babyChairQuantity: 1,
                                                   wheelchairFriendly: false,
                                                   startTime: Date(),
                                                   admitTime: Date())]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activitiesCollectionView.dataSource = self
        activitiesCollectionView.delegate = self
    }
}

extension ActivitiesViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return queueRecords.count
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
        
        activityCell.nameLabel.text = queueRecord.restaurant.name
        activityCell.descriptionLabel.text = "\(queueRecord.groupSize) pax"
        activityCell.estimatedTimeLabel.text = "00:00"
        activityCell.editAction = {
            self.performSegue(withIdentifier: Constants.editQueueSelectedSegue, sender: self)
        }
        if let image = UIImage(named: "c-book-icon") {
            activityCell.queueBookImageView.image = image
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
        case Constants.editQueueSelectedSegue:
            if let indexPaths = self.activitiesCollectionView.indexPathsForSelectedItems {
                let row = indexPaths[0].item
                if let editQueueViewController = segue.destination as? EditQueueViewController {
//                    editQueueViewController.queueRecord = queueRecords[row]
                }
            }
        case Constants.editBookSelectedSegue:
            if let indexPaths = self.activitiesCollectionView.indexPathsForSelectedItems {
                let row = indexPaths[0].item
                if let editBookingViewController = segue.destination as? EditBookingViewController {
//                    editBookingViewController.bookRecord = queueRecords[row]
                }
            }
        default:
            return
        }
    }
}

extension ActivitiesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: self.view.frame.height / 5)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return Constants.activitiesSectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}


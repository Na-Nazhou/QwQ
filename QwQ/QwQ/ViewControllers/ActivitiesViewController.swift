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

    var queueRecords: [QueueRecord] {
           CustomerQueueLogicManager.shared().queueHistory
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activitiesCollectionView.dataSource = self
        activitiesCollectionView.delegate = self

        CustomerQueueLogicManager.shared().activitiesDelegate = self
        CustomerQueueLogicManager.shared().fetchQueueHistory()
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
        
        return activityCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: Constants.queueSelectedSegue, sender: self)
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

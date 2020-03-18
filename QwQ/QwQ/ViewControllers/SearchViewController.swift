//
//  SearchViewController.swift
//  QwQ
//
//  Created by Tan Su Yee on 13/3/20.
//

import UIKit

class SearchViewController: UIViewController, SearchDelegate {

    private let reuseIdentifier = Constants.restaurantReuseIdentifier
    
    @IBOutlet private var restaurantCollectionView: UICollectionView!
    
    var restaurants: [Restaurant] {
        RestaurantLogicManager.shared().restaurants
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
        restaurantCollectionView.delegate = self
        restaurantCollectionView.dataSource = self

        RestaurantLogicManager.shared().searchDelegate = self
        RestaurantLogicManager.shared().fetchRestaurants()
    }

    func restaurantDidSetQueueStatus(restaurant: Restaurant, toIsOpen isOpen: Bool) {
        //TODO
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.restaurantSelectedSegue {
            if let indexPaths = self.restaurantCollectionView.indexPathsForSelectedItems {
                let row = indexPaths[0].item
                RestaurantLogicManager.shared().currentRestaurant = restaurants[row]
            }
        }

        if segue.identifier == Constants.queueSelectedSegue,
            let restaurant = sender as? Restaurant {
            RestaurantLogicManager.shared().currentRestaurant = restaurant
        }
    }
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        restaurants.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView
            .dequeueReusableCell(withReuseIdentifier: Constants.restaurantReuseIdentifier,
                                 for: indexPath)
        
        guard let restaurantCell = cell as? RestaurantCell else {
            return cell
        }
        
        let restaurant = restaurants[indexPath.row]

        restaurantCell.setUpView(restaurant: restaurant)
        restaurantCell.queueAction = {
            if !restaurant.isOpen {
                self.showMessage(title: "Error", message: "This restaurant is currently not open!",
                                 buttonText: Constants.okayTitle, buttonAction: nil)
                return
            }

            if CustomerQueueLogicManager.shared().canQueue(for: restaurant) {
                self.performSegue(withIdentifier: Constants.queueSelectedSegue, sender: restaurant)
            } else {
                self.showMessage(title: "Error", message: "You have an existing queue record",
                                 buttonText: Constants.okayTitle, buttonAction: nil)
            }
        }
        return restaurantCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: Constants.restaurantSelectedSegue, sender: self)
    }
}

extension SearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: self.view.frame.width, height: self.view.frame.height / 5)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        Constants.restaurantSectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
}

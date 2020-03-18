//
//  SearchViewController.swift
//  QwQ
//
//  Created by Tan Su Yee on 13/3/20.
//

import UIKit

class SearchViewController: UIViewController, SearchDelegate {
    
    var filtered: [Restaurant] = []
    var searchActive: Bool = false
    let searchController = UISearchController(searchResultsController: nil)
    
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
        filtered = restaurants
    }

    func restaurantDidSetQueueStatus(restaurant: Restaurant, toIsOpen isOpen: Bool) {
        restaurantCollectionView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.restaurantSelectedSegue {
            if let indexPaths = self.restaurantCollectionView.indexPathsForSelectedItems {
                let row = indexPaths[0].item
                RestaurantLogicManager.shared().currentRestaurant = restaurants[row]
            }
        }

        if segue.identifier == Constants.editQueueSelectedSegue,
            let restaurant = sender as? Restaurant {
            RestaurantLogicManager.shared().currentRestaurant = restaurant
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if !(searchBar.text?.isEmpty)! {
            self.restaurantCollectionView?.reloadData()
        }
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filtered = searchText.isEmpty ? restaurants : restaurants.filter { (item: Restaurant) -> Bool in
            item.name.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
    }
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
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

        let restaurant = filtered[indexPath.row]

        restaurantCell.setUpView(restaurant: restaurant)
        restaurantCell.queueAction = {
            if !restaurant.isOpen {
                self.showMessage(title: Constants.errorTitle,
                                 message: Constants.restaurantUnavailableMessage,
                                 buttonText: Constants.okayTitle)
                return
            }

            if CustomerQueueLogicManager.shared().canQueue(for: restaurant) {
                self.performSegue(withIdentifier: Constants.editQueueSelectedSegue, sender: restaurant)
            } else {
                self.showMessage(title: Constants.errorTitle,
                                 message: Constants.multipleQueueRecordsMessage,
                                 buttonText: Constants.okayTitle)
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

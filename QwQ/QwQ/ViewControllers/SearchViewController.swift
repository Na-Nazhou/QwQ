//
//  SearchViewController.swift
//  QwQ
//
//  Created by Tan Su Yee on 13/3/20.
//

import UIKit

class SearchViewController: UIViewController, SearchDelegate {
    
    private var filter: (Restaurant) -> Bool = { _ in true }
    private var filtered: [Restaurant] {
        restaurants.filter(filter)
    }
    private var searchActive: Bool = false
    private let searchController = UISearchController(searchResultsController: nil)
    
    private var restaurants: [Restaurant] {
        RestaurantLogicManager.shared().restaurants
    }
    
    @IBOutlet private var restaurantCollectionView: UICollectionView!
    
    @IBAction private func handleSort(_ sender: Any) {
        // Get the button frame
        let button = sender as? UIButton
        let buttonFrame = button?.frame ?? CGRect.zero
        
        // Configure the presentation controller
        let popoverContentController = self.storyboard?
            .instantiateViewController(withIdentifier: Constants.popoverContentControllerIdentifier)
            as? PopoverContentController
        popoverContentController?.modalPresentationStyle = .popover
        
        if let popoverPresentationController = popoverContentController?.popoverPresentationController {
            popoverPresentationController.permittedArrowDirections = .up
            popoverPresentationController.sourceView = self.view
            popoverPresentationController.sourceRect = CGRect(
                x: button!.center.x - Constants.popoverContentControllerOffset,
                y: buttonFrame.height,
                width: 80.0,
                height: 80.0)
            popoverPresentationController.delegate = self
            popoverContentController?.delegate = self
            if let popoverController = popoverContentController {
                present(popoverController, animated: true, completion: nil)
            }
        }
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
        restaurantCollectionView.reloadData()
    }
    
    func restaurantCollectionDidLoadNewRestaurant() {
        //TODO: change to filtering based on new array of restaurants.
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

extension SearchViewController: PopoverContentControllerDelegate {
    func popoverContent(controller: PopoverContentController, didselectItem name: String) {
        print("pop")
    }
}

extension SearchViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController
    ) {
        
    }
    
    func popoverPresentationControllerShouldDismissPopover(
        _ popoverPresentationController: UIPopoverPresentationController
    ) -> Bool {
        return true
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.restaurantCollectionView?.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filter = { _ in true }
            return
        }
        filter = { (item: Restaurant) -> Bool in
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
        filtered.count
        //restaurants.count
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
            if !restaurant.isQueueOpen {
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

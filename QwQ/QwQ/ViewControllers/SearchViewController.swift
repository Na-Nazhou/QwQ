//
//  SearchViewController.swift
//  QwQ
//
//  Created by Tan Su Yee on 13/3/20.
//

import UIKit

class SearchViewController: UIViewController, SearchDelegate {

    @IBOutlet private var selectButton: UIButton!
    @IBOutlet private var restaurantCollectionView: UICollectionView!
    @IBOutlet private var queueButton: UIButton!
    @IBOutlet private var bookButton: UIButton!
    
    private var filter: (Restaurant) -> Bool = { _ in true }
    private var sorter: (Restaurant, Restaurant) -> Bool = { _, _  in true }
    private var filtered: [Restaurant] {
        var finalRestaurants = restaurants.filter(filter)
        finalRestaurants.sort(by: sorter)
        return finalRestaurants
    }
    private var searchActive: Bool = false
    private let searchController = UISearchController(searchResultsController: nil)
    private var selectionState = SelectionState.selectOne
    private var selectedRestaurants: [Restaurant] = []
    
    private let bookingLogicManager = CustomerBookingLogicManager()
    private let queueLogicManager = CustomerQueueLogicManager()
    private let restaurantLogicManager = RestaurantLogicManager()
    
    private var restaurants: [Restaurant] {
        restaurantLogicManager.restaurants
    }
    
    enum SelectionState {
        case selectOne
        case selectAll
    }
    
    @IBAction private func handleBook(_ sender: Any) {
        if selectionState == .selectAll {
            guard let items = restaurantCollectionView.indexPathsForSelectedItems else {
                return
            }
            let selectedRestaurants = items.map {
                filtered[$0.item]
            }

            guard !selectedRestaurants.isEmpty else {
                return
            }
            self.performSegue(withIdentifier: Constants.editBookSelectedSegue, sender: selectedRestaurants)
        }
    }
    
    @IBAction private func handleQueue(_ sender: Any) {
        if selectionState == .selectAll {
            guard let items = restaurantCollectionView.indexPathsForSelectedItems else {
                return
            }
            let selectedRestaurants = items.map {
                filtered[$0.item]
            }

            guard !selectedRestaurants.isEmpty else {
                 return
             }
            self.performSegue(withIdentifier: Constants.editQueueSelectedSegue, sender: selectedRestaurants)
        }
    }
    
    @IBAction private func handleSelect(_ sender: Any) {
        if selectionState == .selectOne {
            queueButton.setTitle(Constants.queueButtonTitle, for: .normal)
            bookButton.setTitle(Constants.bookButtonTitle, for: .normal)
            selectButton.setTitle(Constants.selectOneText, for: .normal)
            
            selectionState = .selectAll
            
            restaurantCollectionView.allowsMultipleSelection = true
        } else {
            queueButton.setTitle("", for: .normal)
            bookButton.setTitle("", for: .normal)
            selectButton.setTitle(Constants.selectAllText, for: .normal)
            
            selectionState = .selectOne
            selectedRestaurants = []
            
            restaurantCollectionView.reloadData()
            restaurantCollectionView.allowsMultipleSelection = false
        }
    }
    
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
                width: Constants.popoverWidth,
                height: Constants.popoverHeight
            )
            popoverContentController?.preferredContentSize = CGSize(width: 400, height: 400)
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
        
        restaurantLogicManager.searchDelegate = self
    }

    func didUpdateRestaurantCollection() {
        restaurantCollectionView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.restaurantSelectedSegue {
            if let indexPaths = self.restaurantCollectionView.indexPathsForSelectedItems {
                let row = indexPaths[0].item
                restaurantLogicManager.currentRestaurant = filtered[row]
            }
            
            guard let rVC = segue.destination as? RestaurantViewController else {
                assert(false, "Wrong way of doing this")
                return
            }
            rVC.restaurantLogicManager = restaurantLogicManager
            rVC.queueLogicManager = queueLogicManager
            rVC.bookingLogicManager = bookingLogicManager
        }
        
        if segue.identifier == Constants.editQueueSelectedSegue,
            let restaurants = sender as? [Restaurant] {

            restaurantLogicManager.currentRestaurants = restaurants
            
            guard let editVC = segue.destination as? EditQueueViewController else {
                assert(false, "Wrong way of doing this")
                return
            }
            editVC.restaurantLogicManager = restaurantLogicManager
            editVC.queueLogicManager = queueLogicManager
        }

        if segue.identifier == Constants.editBookSelectedSegue,
            let restaurants = sender as? [Restaurant] {

            restaurantLogicManager.currentRestaurants = restaurants

            guard let editVC = segue.destination as? EditBookingViewController else {
                assert(false, "Wrong way of doing this")
                return
            }
            editVC.restaurantLogicManager = restaurantLogicManager
            editVC.bookingLogicManager = bookingLogicManager
        }
    }
}

extension SearchViewController: PopoverContentControllerDelegate {
    func popoverContent(controller: PopoverContentController, didselectItem name: String) {
        switch name {
        case Constants.sortCriteria[0]:
            handleSortByName()
            restaurantCollectionView.reloadData()
        case Constants.sortCriteria[1]:
            handleSortByLocation()
            restaurantCollectionView.reloadData()
        default:
            break
        }
    }
    
    private func handleSortByName() {
        sorter = { (restaurant: Restaurant, otherRestaurant: Restaurant) -> Bool in
            restaurant.name < otherRestaurant.name
        }
    }
    
    private func handleSortByLocation() {
        sorter = { (restaurant: Restaurant, otherRestaurant: Restaurant) -> Bool in
            restaurant.address < otherRestaurant.address
        }
    }
}

extension SearchViewController: UIPopoverPresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        .none
    }
    
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController
    ) {
        
    }
    
    func popoverPresentationControllerShouldDismissPopover(
        _ popoverPresentationController: UIPopoverPresentationController
    ) -> Bool {
        true
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
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView
            .dequeueReusableCell(withReuseIdentifier: Constants.restaurantReuseIdentifier,
                                 for: indexPath)
        
        guard let restaurantCell = cell as? RestaurantCell else {
            return cell
        }
        
        let restaurant = filtered[indexPath.item]
        
        restaurantCell.backgroundColor = Constants.deselectedRestaurantColor
        restaurantCell.setUpView(restaurant: restaurant)
        restaurantCell.queueAction = {
            if !restaurant.isQueueOpen {
                self.showMessage(title: Constants.errorTitle,
                                 message: String(format: Constants.restaurantUnavailableMessage, restaurant.name),
                                 buttonText: Constants.okayTitle)
                return
            }
            
            if !self.queueLogicManager.canQueue(for: restaurant) {
                self.showMessage(title: Constants.errorTitle,
                                 message: String(format: Constants.alreadyQueuedRestaurantMessage, restaurant.name), 
                                 buttonText: Constants.okayTitle)
                return
            }
            
            self.performSegue(withIdentifier: Constants.editQueueSelectedSegue, sender: [restaurant])
        }
        return restaurantCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if selectionState == .selectAll {
            let cell = collectionView.cellForItem(at: indexPath)
            if cell?.isSelected == true {
                selectedRestaurants.append(filtered[indexPath.item])
                cell?.backgroundColor = Constants.selectedRestaurantColor
            }
        } else if selectionState == .selectOne {
            performSegue(withIdentifier: Constants.restaurantSelectedSegue, sender: self)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        let restaurantToBeRemoved = filtered[indexPath.item]
        selectedRestaurants = selectedRestaurants.filter {
            $0 != restaurantToBeRemoved
        }
        cell?.backgroundColor = Constants.deselectedRestaurantColor
    }
}

//
//  SearchViewController.swift
//  QwQ
//
//  Created by Tan Su Yee on 13/3/20.
//

/**
`SearchViewController` displays all restaurants and enables searching for restaurants.
 
 It must conform to `PopoverContentControllerDelegate` and `UIPopoverPresentationControllerDelegate` to enable display of sorting criteria in a popover format.
 It must conform to `UISearchBarDelegate` and `SearchDelegate` to enable searching of restaurants.
*/

import UIKit
import os

class SearchViewController: UIViewController {

    // MARK: View properties
    @IBOutlet private var selectButton: UIButton!
    @IBOutlet private var restaurantCollectionView: UICollectionView!
    @IBOutlet private var queueButton: UIButton!
    @IBOutlet private var bookButton: UIButton!

    // MARK: Search and sort
    private var searchActive: Bool = false
    private let searchController = UISearchController(searchResultsController: nil)

    private var filter: (Restaurant) -> Bool = { _ in true }
    private var sorter: (Restaurant, Restaurant) -> Bool = { $0.name < $1.name }
    private var filtered: [Restaurant] {
        restaurants.filter(filter).sorted(by: sorter)
    }

    // MARK: Multi-select
    private var selectionState = SelectionState.selectOne
    private enum SelectionState {
        case selectOne
        case selectAll
    }
    private var selectedRestaurants: [Restaurant] {
        if selectionState == .selectAll {
            guard let items = restaurantCollectionView.indexPathsForSelectedItems else {
                return []
            }
            return items.map { filtered[$0.item] }
        }
        return []
    }

    // MARK: Logic properties
    private let bookingLogic: CustomerBookingLogic = CustomerBookingLogicManager()
    private let queueLogic: CustomerQueueLogic = CustomerQueueLogicManager()
    private let restaurantLogic: RestaurantLogic = RestaurantLogicManager()

    // MARK: Model properties
    private var restaurants: [Restaurant] {
        restaurantLogic.restaurants
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
        restaurantCollectionView.delegate = self
        restaurantCollectionView.dataSource = self
        
        restaurantLogic.searchDelegate = self
        queueLogic.searchDelegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        reloadRestaurants()

        super.viewWillAppear(animated)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case Constants.restaurantSelectedSegue:
            guard let restaurant = sender as? Restaurant,
                let rVC = segue.destination as? RestaurantViewController else {
                    assert(false, "Wrong way of doing this")
                    return
            }

            restaurantLogic.currentRestaurant = restaurant
            rVC.restaurantLogic = restaurantLogic
            rVC.queueLogic = queueLogic
            rVC.bookingLogic = bookingLogic
        case Constants.editQueueSelectedSegue:
            guard let restaurants = sender as? [Restaurant],
                let editVC = segue.destination as? EditQueueViewController else {
                    assert(false, "Wrong way of doing this")
                    return
            }
            restaurantLogic.currentRestaurants = restaurants
            editVC.restaurantLogic = restaurantLogic
            editVC.queueLogic = queueLogic
        case Constants.editBookSelectedSegue:
            guard let restaurants = sender as? [Restaurant],
                let editVC = segue.destination as? EditBookingViewController else {
                assert(false, "Wrong way of doing this")
                return
            }
            restaurantLogic.currentRestaurants = restaurants
            editVC.restaurantLogic = restaurantLogic
            editVC.bookingLogic = bookingLogic
        default:
            os_log("Segue not found.", log: Log.segueError, type: .error)
            assert(false)
        }
    }

    // MARK: Multi-select

    /// Update view to match selection state
    @IBAction private func handleSelect(_ sender: Any) {
        if selectionState == .selectOne {
            queueButton.setTitle(Constants.queueButtonTitle, for: .normal)
            bookButton.setTitle(Constants.bookButtonTitle, for: .normal)
            selectButton.setTitle(Constants.selectOneText, for: .normal)

            selectionState = .selectAll

            restaurantCollectionView.allowsMultipleSelection = true
        } else if selectionState == .selectAll {
            queueButton.setTitle("", for: .normal)
            bookButton.setTitle("", for: .normal)
            selectButton.setTitle(Constants.selectAllText, for: .normal)

            selectionState = .selectOne

            reloadRestaurants()
            restaurantCollectionView.allowsMultipleSelection = false
        } else {
            os_log("Unknown selection state.", log: Log.selectionStateError, type: .error)
        }
    }

    /// Make reservations at selected restaurants
    @IBAction private func handleBook(_ sender: Any) {
        guard checkSelectedRestaurants() else {
            return
        }
        self.performSegue(withIdentifier: Constants.editBookSelectedSegue,
                          sender: selectedRestaurants)
    }

    /// Queue at selected restaurants
    @IBAction private func handleQueue(_ sender: Any) {
        guard checkSelectedRestaurants() else {
            return
        }

        for restaurant in selectedRestaurants {
            if !checkRestaurantQueue(for: restaurant) {
                return
            }
        }
        self.performSegue(withIdentifier: Constants.editQueueSelectedSegue,
                          sender: selectedRestaurants)
    }

    private func checkSelectedRestaurants() -> Bool {
        if selectedRestaurants.isEmpty {
            showMessage(title: Constants.errorTitle,
                        message: Constants.noRestaurantSelectedMessage,
                        buttonText: Constants.okayTitle)
            return false
        }

        return true
    }

    // MARK: Sort

    /// Sort restaurants according to filter criteria
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
}

extension SearchViewController: PopoverContentControllerDelegate {
    func popoverContent(controller: PopoverContentController, didselectItem name: String) {
        switch name {
        case Constants.sortCriteria[0]:
            handleSortByName()
            reloadRestaurants()
        case Constants.sortCriteria[1]:
            handleSortByLocation()
            reloadRestaurants()
        default:
            break
        }
    }
    
    /// Sort restaurant names in ascending alphabetical order
    private func handleSortByName() {
        sorter = { (restaurant: Restaurant, otherRestaurant: Restaurant) -> Bool in
            restaurant.name < otherRestaurant.name
        }
    }
    
    /// Sort restaurant locations in ascending alphabetical order
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
        reloadRestaurants()
    }
    
    /// Filter restaurants based on search text
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filter = { _ in true }
            return
        }
        
        // Set filter to search text
        filter = { (item: Restaurant) -> Bool in
            item.name.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
    }
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    /// Set up search bar header
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
    
    /// Set up restaurant cells based on filtered restaurants
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView
            .dequeueReusableCell(withReuseIdentifier: Constants.restaurantReuseIdentifier,
                                 for: indexPath)
        
        guard let restaurantCell = cell as? RestaurantCell else {
            return cell
        }
        
        // Set up restaurant details
        let restaurant = filtered[indexPath.item]
        
        restaurantCell.backgroundColor = Constants.deselectedRestaurantColor
        restaurantCell.canQueue = queueLogic.canQueue(for: restaurant)
        restaurantCell.setUpView(restaurant: restaurant)
        restaurantCell.queueAction = {
            guard self.checkRestaurantQueue(for: restaurant) else {
                return false
            }
            self.performSegue(withIdentifier: Constants.editQueueSelectedSegue, sender: [restaurant])
            return true
        }
        return restaurantCell
    }

    @discardableResult
    private func checkRestaurantQueue(for restaurant: Restaurant) -> Bool {
        guard !queueLogic.canQueue(for: restaurant) else {
            return true
        }
        var format = Constants.alreadyQueuedRestaurantMessage
        if !restaurant.isQueueOpen {
            format = Constants.restaurantUnavailableMessage
        }

        showMessage(title: Constants.errorTitle,
                    message: String(format: format, restaurant.name),
                    buttonText: Constants.okayTitle)
        return false
    }
    
    /// Segue to restaurant view controller to view selected restaurant details if selection state is selectOne
    /// Else add restaurant to selected restaurants and highlight restaurant cell
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if selectionState == .selectAll {
            let cell = collectionView.cellForItem(at: indexPath)
            if cell?.isSelected == true {
                cell?.backgroundColor = Constants.selectedRestaurantColor
            }
        } else if selectionState == .selectOne {
            let selectedRestaurant = filtered[indexPath.item]
            performSegue(withIdentifier: Constants.restaurantSelectedSegue, sender: selectedRestaurant)
        }
    }
    
    /// Change restaurant cell color back to unhighlighted color
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = Constants.deselectedRestaurantColor
    }
}

extension SearchViewController: SearchDelegate {
    func didUpdateRestaurantCollection() {
        reloadRestaurants()
    }

    func didUpdateQueueRecordCollection() {
        reloadRestaurants()
    }

    private func reloadRestaurants() {
        restaurantCollectionView.reloadData()
    }
}

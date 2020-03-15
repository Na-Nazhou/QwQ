//
//  SearchViewController.swift
//  QwQ
//
//  Created by Tan Su Yee on 13/3/20.
//

import UIKit

class SearchViewController: UIViewController {
    
    private let reuseIdentifier = Constants.restaurantReuseIdentifier
    
    @IBOutlet weak var restaurantCollectionView: UICollectionView!
    
    var restaurants: [Restaurant] = [
        Restaurant(uid: "1", name: "restaurant1", email: "j@mail.com", menu: "menu", address: "location"),
        Restaurant(uid: "2", name: "restaurant2", email: "k@mail.com", menu: "menu", address: "location"),
        Restaurant(uid: "3", name: "restaurant3", email: "l@mail.com", menu: "menu", address: "location")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hideKeyboardWhenTappedAround()
        
        restaurantCollectionView.delegate = self
        restaurantCollectionView.dataSource = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.restaurantSelectedSegue {
            if let restaurantViewController = segue.destination as? RestaurantViewController {
                if let indexPaths = self.restaurantCollectionView.indexPathsForSelectedItems {
                    let row = indexPaths[0].item
                    restaurantViewController.restaurant = restaurants[row]
                }
            }
        }
    }
}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return restaurants.count
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
        
        restaurantCell.nameLabel.text = restaurant.name
        restaurantCell.locationLabel.text = restaurant.address
        
        restaurantCell.queueAction = {
            self.performSegue(withIdentifier: Constants.queueSelectedSegue, sender: indexPath)
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
        return CGSize(width: self.view.frame.width, height: self.view.frame.height / 5)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return Constants.restaurantSectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

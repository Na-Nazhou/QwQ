//
//  SearchDelegate.swift
//  QwQ
//
//  Created by Nazhou Na on 16/3/20.
//

/// Protocol for delegate of restaurant logic presentation to follow.
protocol SearchDelegate: AnyObject {

    func restaurantDidSetQueueStatus(restaurant: Restaurant, toIsOpen isOpen: Bool)

    func restaurantCollectionDidLoadNewRestaurant()
    func restaurantCollectionDidRemoveRestaurant()
}

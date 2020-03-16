//
//  RestaurantDelegate.swift
//  QwQ
//
//  Created by Nazhou Na on 16/3/20.
//

/// Protocol for delegate of restaurant logic presentation to follow.
protocol RestaurantDelegate: AnyObject {

    func restaurantDidSetQueueStatus(toIsOpen isOpen: Bool)
}

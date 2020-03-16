//
//  ProfileStorage.swift
//  QwQ-restaurant
//
//  Created by Daniel Wong on 18/3/20.
//

import UIKit

protocol ProfileStorage {

    func setDelegate(delegate: ProfileDelegate)

    func getRestaurantInfo()

    func updateRestaurantInfo(restaurant: Restaurant)

}

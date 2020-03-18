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

    func getRestaurantProfilePic(uid: String, placeholder imageView: UIImageView)

    func updateRestaurantInfo(restaurant: Restaurant)

    func updateRestaurantProfilePic(uid: String, image: UIImage)

}

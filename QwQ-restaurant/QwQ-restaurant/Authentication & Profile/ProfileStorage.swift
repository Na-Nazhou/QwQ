//
//  ProfileStorage.swift
//  QwQ-restaurant
//
//  Created by Daniel Wong on 18/3/20.
//

import UIKit

protocol ProfileStorage {

    // MARK: - Restaurant Creation Methods

    static func createInitialRestaurantProfile(uid: String,
                                             signupDetails: SignupDetails,
                                             authDetails: AuthDetails,
                                             errorHandler: @escaping (Error) -> Void)

    // MARK: - Restaurant Info Retrieval Methods

    static func getRestaurantInfo(completion: @escaping (Restaurant) -> Void,
                                errorHandler: @escaping (Error) -> Void)

    static func getRestaurantProfilePic(uid: String,
                                      placeholder imageView: UIImageView)

    // MARK: - Restaurant Info Update Methods

    static func updateRestaurantInfo(restaurant: Restaurant,
                                   completion: @escaping () -> Void,
                                   errorHandler: @escaping (Error) -> Void)

    static func updateRestaurantProfilePic(uid: String,
                                         image: UIImage,
                                         errorHandler: @escaping (Error) -> Void)

}


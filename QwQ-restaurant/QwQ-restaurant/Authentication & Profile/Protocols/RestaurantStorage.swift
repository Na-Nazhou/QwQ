//
//  ProfileStorage.swift
//  QwQ-restaurant
//
//  Created by Daniel Wong on 18/3/20.
//

import UIKit

protocol RestaurantStorage {

    static var currentRestaurantUID: String? { get set }

    // MARK: - Restaurant Creation Methods
    
    static func createInitialRestaurantProfile(uid: String,
                                               signupDetails: SignupDetails,
                                               email: String,
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

    static func setDefaultRole(roleName: String, errorHandler: @escaping (Error) -> Void)

    // MARK: - Restaurant Listener

    static func registerListener(for restaurant: Restaurant)

    static func removeListener()
}

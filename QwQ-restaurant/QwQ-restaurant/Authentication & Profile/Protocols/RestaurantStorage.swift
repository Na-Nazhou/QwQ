//
//  ProfileStorage.swift
//  QwQ-restaurant
//
//  Created by Daniel Wong on 18/3/20.
//

import UIKit

/// This protocol specifies the methods than a compatible profile storage should support.
protocol RestaurantStorage {

    /// For all of the methods below, the following parameters, if applicable, serve the following purpose:
    /// - Parameters:
    ///     - completion: A closure to be called upon completion of that method
    ///     - errorHandler: A closure that takes an Error type that handles errors

    /// Holds the UID of the Restaurant assigned to the current user
    static var currentRestaurantUID: String? { get set }

    // MARK: - Restaurant Creation Methods

    /// Creates the initial Restaurant profile upon signup
    /// - Parameters:
    ///     - uid: The uid of the user to be created
    ///     - signupDetails: A SignupDetails object including the name and the contact of the user
    ///     - email: The email of the user to be created
    static func createInitialRestaurantProfile(uid: String,
                                               signupDetails: SignupDetails,
                                               email: String,
                                               errorHandler: @escaping (Error) -> Void)
    
    // MARK: - Restaurant Info Retrieval Methods

    /// This function retrieves the respective Restaurant object based on the currentRestaurantUID
    static func getRestaurantInfo(completion: @escaping (Restaurant) -> Void,
                                  errorHandler: @escaping (Error) -> Void)

    /// This function gets a Restaurant's profile photo based on the specified UID
    static func getRestaurantProfilePic(uid: String,
                                        placeholder imageView: UIImageView)
    
    // MARK: - Restaurant Info Update Methods

    /// This function updates the Restaurant's info
    /// - Parameters:
    ///     - customer: The Restaurant to be updated
    static func updateRestaurantInfo(restaurant: Restaurant,
                                     completion: @escaping () -> Void,
                                     errorHandler: @escaping (Error) -> Void)

    /// This function updates the Restaurant's profile photo
    /// - Parameters:
    ///     - uid: The uid of the Restaurant to be updated
    ///     - image: The image to be uploaded
    static func updateRestaurantProfilePic(uid: String,
                                           image: UIImage,
                                           errorHandler: @escaping (Error) -> Void)

    /// This function updates the current Restaurant's default role
    /// - Parameters:
    ///     - roleName: The new default role to be set
    static func setDefaultRole(roleName: String, errorHandler: @escaping (Error) -> Void)

    // MARK: - Restaurant Listener

    /// This function registers a listener for a specified Restaurant
    static func registerListener(for restaurant: Restaurant)

    /// This function removes the previously-registered listener.
    static func removeListener()
}

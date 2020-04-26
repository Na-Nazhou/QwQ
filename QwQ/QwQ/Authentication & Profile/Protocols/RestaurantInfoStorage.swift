//
//  RestaurantInfoStorage.swift
//  QwQ
//
//  Created by Daniel Wong on 19/3/20.
//

import UIKit

/// This protocol specifies the methods than a compatible Restaurant storage should support.
protocol RestaurantInfoStorage {

    /// For all of the methods below, the following parameters, if applicable, serve the following purpose:
    /// - Parameters:
    ///     - completion: A closure to be called upon completion of that method
    ///     - errorHandler: A closure that takes an Error type that handles errors

    /// This function retrieves the Restaurant based on the specified UID
    /// - Parameters:
    ///     - uid: The uid of the restaurant to retrieve
    static func getRestaurantFromUID(uid: String,
                                     completion: @escaping (Restaurant) -> Void,
                                     errorHandler: ((Error) -> Void)?)

    /// This function retrieves the Restaurant's profile photo based on the specified UID
    /// - Parameters:
    ///     - uid: The uid of the Restaurant to retrieve the profile photo for
    ///     - imageView: The ImageView to load the image into
    static func getRestaurantProfilePic(uid: String, imageView: UIImageView)
    
}

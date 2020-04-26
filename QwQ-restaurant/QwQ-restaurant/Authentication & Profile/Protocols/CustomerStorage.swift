//
//  RestaurantStorage.swift
//  QwQ-restaurant
//
//  Created by Daniel Wong on 19/3/20.
//

import UIKit

/// This protocol specifies the methods than a compatible Restaurant storage should support.
protocol CustomerStorage {

    /// For all of the methods below, the following parameters, if applicable, serve the following purpose:
    /// - Parameters:
    ///     - completion: A closure to be called upon completion of that method
    ///     - errorHandler: A closure that takes an Error type that handles errors

    /// This function retrieves the Customer based on the specified UID
    /// - Parameters:
    ///     - uid: The uid of the customer to retrieve
    static func getCustomerFromUID(uid: String,
                                   completion: @escaping (Customer) -> Void,
                                   errorHandler: ((Error) -> Void)?)

    /// This function retrieves the Customer's profile photo based on the specified UID
    /// - Parameters:
    ///     - uid: The uid of the Customer to retrieve the profile photo for
    ///     - imageView: The ImageView to load the image into
    static func getCustomerProfilePic(uid: String, imageView: UIImageView)
}

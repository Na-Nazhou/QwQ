//
//  UserStorage.swift
//  QwQ
//
//  Created by Daniel Wong on 11/3/20.
//

import UIKit

/// This protocol specifies the methods than a compatible profile storage should support.
protocol ProfileStorage {

    /// For all of the methods below, the following parameters, if applicable, serve the following purpose:
    /// - Parameters:
    ///     - completion: A closure to be called upon completion of that method
    ///     - errorHandler: A closure that takes an Error type that handles errors

    /// Holds the UID of the currently logged in user
    static var currentUID: String? { get set }

    /// Holds the authentication type (source) of the currently logged in user
    static var currentAuthType: AuthTypes? { get set }

    // MARK: - Customer Creation Methods

    /// Creates the initial customer profile upon signup
    /// - Parameters:
    ///     - uid: The uid of the user to be created
    ///     - signupDetails: A SignupDetails object including the name and the contact of the user
    ///     - email: The email of the user to be created
    static func createInitialCustomerProfile(uid: String,
                                             signupDetails: SignupDetails,
                                             email: String,
                                             errorHandler: @escaping (Error) -> Void)

    // MARK: - Customer Info Retrieval Methods

    /// This function retrieves the respective Customer object based on the currentUID set
    static func getCustomerInfo(completion: @escaping (Customer) -> Void,
                                errorHandler: @escaping (Error) -> Void)

    /// This function gets a customer's profile photo based on the specified UID
    static func getCustomerProfilePic(uid: String,
                                      placeholder imageView: UIImageView)

    // MARK: - Customer Info Update Methods

    /// This function updates the customer info
    /// - Parameters:
    ///     - customer: The customer to be updated
    static func updateCustomerInfo(customer: Customer,
                                   completion: @escaping () -> Void,
                                   errorHandler: @escaping (Error) -> Void)

    /// This function updates the customer's profile photo
    /// - Parameters:
    ///     - uid: The uid of the customer to be updated
    ///     - image: The image to be uploaded
    static func updateCustomerProfilePic(uid: String,
                                         image: UIImage,
                                         errorHandler: @escaping (Error) -> Void)

}

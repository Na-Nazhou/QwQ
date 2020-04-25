//
//  UserStorage.swift
//  QwQ
//
//  Created by Daniel Wong on 11/3/20.
//

import UIKit

protocol ProfileStorage {

    static var currentUID: String? { get set }
    static var currentAuthType: AuthTypes? { get set }

    // MARK: - Customer Creation Methods

    static func createInitialCustomerProfile(uid: String,
                                             signupDetails: SignupDetails,
                                             email: String,
                                             errorHandler: @escaping (Error) -> Void)

    // MARK: - Customer Info Retrieval Methods
    
    static func getCustomerInfo(completion: @escaping (Customer) -> Void,
                                errorHandler: @escaping (Error) -> Void)

    static func getCustomerProfilePic(uid: String,
                                      placeholder imageView: UIImageView)

    // MARK: - Restaurant Profile Retrieval Methods
//    static func getRestaurantProfilePic(uid: String, completion: @escaping (UIImage) -> Void)

    // MARK: - Customer Info Update Methods

    static func updateCustomerInfo(customer: Customer,
                                   completion: @escaping () -> Void,
                                   errorHandler: @escaping (Error) -> Void)

    static func updateCustomerProfilePic(uid: String,
                                         image: UIImage,
                                         errorHandler: @escaping (Error) -> Void)

}
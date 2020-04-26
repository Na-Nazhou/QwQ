//
//  LoginLogicDelegate.swift
//  QwQ-restaurant
//
//  Created by Daniel Wong on 11/4/20.
//

protocol LoginLogicDelegate: AnyObject {

    /// To be called upon completion of the login process
    func loginComplete()

    /// Called if the email of the user to be signed in is not verified
    func emailNotVerified()

    /// Called if the user has not yet been assigned to any Restaurant
    func noAssignedRestaurant()

    /// Called if the user has not been assigned to any Role in the Restaurant
    func noAssignedRole()

    /// To be called to handle errors
    func handleError(error: Error)
    
}

//
//  SignupLogicDelegate.swift
//  QwQ-restaurant
//
//  Created by Daniel Wong on 11/4/20.
//

/// This protocol defines the methods that a signupLogicDelegate must support
protocol SignupLogicDelegate: AnyObject {

    /// To be called upon completion of the signup process
    func signUpComplete()

    /// To be called to handle errors
    func handleError(error: Error)
}

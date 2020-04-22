//
//  SignupLogicDelegate.swift
//  QwQ-restaurant
//
//  Created by Daniel Wong on 11/4/20.
//

protocol SignupLogicDelegate: AnyObject {

    func signUpComplete()

    func handleError(error: Error)
}

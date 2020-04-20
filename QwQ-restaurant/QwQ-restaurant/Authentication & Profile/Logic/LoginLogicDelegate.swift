//
//  LoginLogicDelegate.swift
//  QwQ-restaurant
//
//  Created by Daniel Wong on 11/4/20.
//

protocol LoginLogicDelegate: AnyObject {

    func loginComplete()

    func emailNotVerified()

    func noAssignedRestaurant()

    func handleError(error: Error)
    
}

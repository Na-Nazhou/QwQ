//
//  Authenticator.swift
//  QwQ
//
//  Created by Daniel Wong on 11/3/20.
//

import UIKit

protocol Authenticator {
    
    static func signup(signupDetails: SignupDetails,
                       authDetails: AuthDetails,
                       completion: @escaping () -> Void,
                       errorHandler: @escaping (Error) -> Void)

    static func login(authDetails: AuthDetails,
                      completion: @escaping () -> Void,
                      errorHandler: @escaping (Error) -> Void)

    static func logout(completion: @escaping () -> Void, errorHandler: @escaping (Error) -> Void)

    static func changePassword(_ password: String, errorHandler: @escaping (Error) -> Void)

    static func sendVerificationEmail(errorHandler: @escaping (Error) -> Void)

    static func checkIfEmailVerified() -> Bool

    static func checkIfAlreadyLoggedIn() -> Bool

    static func initAlreadyLoggedInUser()

    static func resetPassword(for email: String,
                              completion: @escaping () -> Void,
                              errorHandler: @escaping (Error) -> Void)

}
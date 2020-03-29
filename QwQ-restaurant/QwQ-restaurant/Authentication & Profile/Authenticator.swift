//
//  Authenticator.swift
//  QwQ-restaurant
//
//  Created by Daniel Wong on 15/3/20.
//

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

    static func checkIfAlreadyLoggedIn() -> Bool

    static func getUIDOfCurrentUser() -> String?

}

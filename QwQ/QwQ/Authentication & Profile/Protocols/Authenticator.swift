//
//  Authenticator.swift
//  QwQ
//
//  Created by Daniel Wong on 11/3/20.
//

import UIKit

/// This protocol specifies the methods than a compatible authenticator should support.
protocol Authenticator {

    /// For all of the methods below, the following parameters, if applicable, serve the following purpose:
    /// - Parameters:
    ///     - completion: A closure to be called upon completion of that method
    ///     - errorHandler: A closure that takes an Error type that handles errors

    // MARK: - Signup/login/logout methods

    /// Creates a new account.
    /// Must create corresponding customer profile with ProfileStorage upon completion
    /// - Parameters:
    ///     - signupDetails: A SignupDetails object representing the email and the name of the user
    ///     - authDetails: An AuthDetails object representing the email and password of the user
    static func signup(signupDetails: SignupDetails,
                       authDetails: AuthDetails,
                       completion: @escaping () -> Void,
                       errorHandler: @escaping (Error) -> Void)

    /// Signs into an account
    /// Needs to set ProfileStorage's currentUID and currentAuthType upon completion.
    /// - Parameters:
    ///     - authDetails: An AuthDetails object representing the email and password of the user
    static func login(authDetails: AuthDetails,
                      completion: @escaping () -> Void,
                      errorHandler: @escaping (Error) -> Void)

    /// Logs out the current user
    /// Needs to clear ProfileStorage's currentUID and currentAuthType upon completion.
    static func logout(completion: @escaping () -> Void, errorHandler: @escaping (Error) -> Void)

    // MARK: - Change password/verification methods

    /// Changes the user's password
    /// - Parameters:
    ///     - password: The new user password
    static func changePassword(_ password: String, errorHandler: @escaping (Error) -> Void)

    /// Resets the user's password. Requires email as this is done without being signed in.
    /// - Parameters:
    ///     - email: The email of the user who is requesting a password reset
    static func resetPassword(for email: String,
                              completion: @escaping () -> Void,
                              errorHandler: @escaping (Error) -> Void)

    /// Re-sends an verification email to a signed in user who has not passed email verification
    static func sendVerificationEmail(errorHandler: @escaping (Error) -> Void)

    // MARK: - Check user authentication status methods

    /// Checks if a user has verified their email
    static func checkIfEmailVerified() -> Bool

    /// Checks if the user is already logged in from a previous session
    static func checkIfAlreadyLoggedIn() -> Bool

    /// Sets the ProfileStorage's currentUID and currentAuthType for already logged in user
    static func initAlreadyLoggedInUser()

}

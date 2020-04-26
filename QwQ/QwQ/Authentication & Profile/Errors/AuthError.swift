//
//  AuthError.swift
//  QwQ
//
//  Created by Daniel Wong on 19/3/20.
//

import Foundation

/// Contains the possible errors thrown by Authenticator
enum AuthError: Error {
    case AuthResultError
    case SignOutError
    case NotSignedIn
}

/// Descriptions for each AuthError
extension AuthError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .AuthResultError:
            return "An error occured retrieving the authentication result."
        case .SignOutError:
            return "An error occured while trying to sign out."
        case .NotSignedIn:
            return "You are not signed in."
        }
    }
}

//
//  AuthError.swift
//  QwQ-restaurant
//
//  Created by Daniel Wong on 20/3/20.
//

import Foundation

enum AuthError: Error {
    case AuthResultError
    case SignOutError
    case NotSignedIn
}

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

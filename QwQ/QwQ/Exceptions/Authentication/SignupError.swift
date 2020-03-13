//
//  SignupError.swift
//  QwQ
//
//  Created by Daniel Wong on 11/3/20.
//

enum SignupError: Error {
    case invalidEmail
    case invalidPassword
    case emailExists
    case firebaseError(error: String)
}

//
//  NoSuchUserException.swift
//  QwQ
//
//  Created by Daniel Wong on 11/3/20.
//

enum LoginError: Error {
    case invalidUser
    case invalidPassword
    case firebaseError(error: String)
}

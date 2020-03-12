//
//  Authenticator.swift
//  QwQ
//
//  Created by Daniel Wong on 11/3/20.
//

protocol Authenticator {

    func signup(name: String, email: String, password: String) throws -> String

    func login(email: String, password: String) throws -> String
}

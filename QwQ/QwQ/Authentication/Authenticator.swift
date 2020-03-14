//
//  Authenticator.swift
//  QwQ
//
//  Created by Daniel Wong on 11/3/20.
//

protocol Authenticator {

    func setDelegate(view: AuthDelegate)

    func signup(name: String, contact: String, email: String, password: String)

    func login(email: String, password: String)
}

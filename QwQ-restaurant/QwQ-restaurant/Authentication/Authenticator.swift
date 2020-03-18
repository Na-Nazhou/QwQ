//
//  Authenticator.swift
//  QwQ-restaurant
//
//  Created by Daniel Wong on 15/3/20.
//

protocol Authenticator {

    func setDelegate(delegate: AuthDelegate)

    func signup(name: String, contact: String, email: String, password: String)

    func login(email: String, password: String)

    func logout()

    func checkIfAlreadyLoggedIn()

}

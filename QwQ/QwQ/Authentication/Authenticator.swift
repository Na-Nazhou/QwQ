//
//  Authenticator.swift
//  QwQ
//
//  Created by Daniel Wong on 11/3/20.
//

import UIKit

protocol Authenticator {

    func setDelegate(delegate: AuthDelegate)

    func signup(name: String, contact: String, email: String, password: String)

    func login(email: String, password: String)

    func logout()

    func checkIfAlreadyLoggedIn()
    
}

protocol AuthDelegate: AnyObject {

    func authCompleted()

    func showMessage(title: String, message: String, buttonText: String, buttonAction: ((UIAlertAction) -> Void)?)

}

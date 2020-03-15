//
//  AuthDelegate.swift
//  QwQ-restaurant
//
//  Created by Daniel Wong on 15/3/20.
//

protocol AuthDelegate: AnyObject {

    func showMessage(title: String, message: String, buttonText: String)

    func authSucceeded()
}

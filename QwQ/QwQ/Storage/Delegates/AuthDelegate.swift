//
//  DelegateViewController.swift
//  QwQ
//
//  Created by Daniel Wong on 13/3/20.
//

protocol AuthDelegate: AnyObject {

    func showMessage(title: String, message: String, buttonText: String)

    func authSucceeded()
}

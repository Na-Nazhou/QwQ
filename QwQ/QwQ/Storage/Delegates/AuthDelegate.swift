//
//  DelegateViewController.swift
//  QwQ
//
//  Created by Daniel Wong on 13/3/20.
//

import UIKit

protocol AuthDelegate: AnyObject {

    func authCompleted()

    func showMessage(title: String, message: String, buttonText: String, buttonAction: ((UIAlertAction) -> Void)?)

}

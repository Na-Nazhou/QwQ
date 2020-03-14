//
//  ProfileDelegate.swift
//  QwQ
//
//  Created by Daniel Wong on 14/3/20.
//

import UIKit

protocol ProfileDelegate: AnyObject {

    func getCustomerInfoComplete(customer: Customer)

    func updateComplete()

    func showMessage(title: String, message: String, buttonText: String)

}

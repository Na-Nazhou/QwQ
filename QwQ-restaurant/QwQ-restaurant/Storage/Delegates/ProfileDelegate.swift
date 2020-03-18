//
//  ProfileDelegate.swift
//  QwQ-restaurant
//
//  Created by Daniel Wong on 18/3/20.
//

import UIKit

protocol ProfileDelegate: AnyObject {

    func getCustomerInfoComplete(customer: Customer)

    func updateComplete()

    func showMessage(title: String, message: String, buttonText: String)

}

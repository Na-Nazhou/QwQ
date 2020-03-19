//
//  UserStorage.swift
//  QwQ
//
//  Created by Daniel Wong on 11/3/20.
//

import UIKit

protocol ProfileStorage {

    func setDelegate(delegate: ProfileDelegate)

    func getCustomerInfo()

    func getCustomerProfilePic(uid: String, placeholder imageView: UIImageView)

    func updateCustomerInfo(customer: Customer)

    func updateCustomerProfilePic(uid: String, image: UIImage)

}

protocol ProfileDelegate: AnyObject {

    func getCustomerInfoComplete(customer: Customer)

    func updateComplete()

    func showMessage(title: String, message: String, buttonText: String, buttonAction: ((UIAlertAction) -> Void)?)

}

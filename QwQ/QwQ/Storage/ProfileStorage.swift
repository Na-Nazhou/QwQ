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

    func updateCustomerInfo(customer: Customer)

}

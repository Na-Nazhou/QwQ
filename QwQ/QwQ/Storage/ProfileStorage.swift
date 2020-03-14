//
//  UserStorage.swift
//  QwQ
//
//  Created by Daniel Wong on 11/3/20.
//

protocol ProfileStorage {

    func getCustomer() -> Customer

    func updateCustomer(customer: Customer)
    
}

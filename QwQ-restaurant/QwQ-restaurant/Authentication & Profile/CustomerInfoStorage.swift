//
//  RestaurantStorage.swift
//  QwQ-restaurant
//
//  Created by Daniel Wong on 19/3/20.
//

protocol CustomerInfoStorage {
    static func getCustomerFromUID(uid: String,
                                   completion: @escaping (Customer) -> Void,
                                   errorHandler: ((Error) -> Void)?)
}

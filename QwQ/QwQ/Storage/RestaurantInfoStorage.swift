//
//  RestaurantInfoStorage.swift
//  QwQ
//
//  Created by Daniel Wong on 19/3/20.
//

protocol RestaurantInfoStorage {

    static func getRestaurantFromUID(uid: String,
                                     completion: @escaping (Restaurant) -> Void,
                                     errorHandler: ((Error) -> Void)?)
    
}

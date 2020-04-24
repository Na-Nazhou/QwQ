//
//  StaffStorage.swift
//  QwQ-restaurant
//
//  Created by Daniel Wong on 23/4/20.
//

protocol StaffPositionStorage {

    static func getAllStaffPositions(completion: @escaping ([StaffPosition]) -> Void,
                                      errorHandler: @escaping (Error) -> Void)
    
}

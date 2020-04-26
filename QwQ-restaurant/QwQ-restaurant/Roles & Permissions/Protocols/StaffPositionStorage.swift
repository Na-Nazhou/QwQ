//
//  StaffStorage.swift
//  QwQ-restaurant
//
//  Created by Daniel Wong on 23/4/20.
//

/// This protocol specifies the methods that a compatible Staff Position Storage should support.
protocol StaffPositionStorage {

    /// Retrieve all the Staff Positions associated with the current restaurant.
    static func getAllStaffPositions(completion: @escaping ([StaffPosition]) -> Void,
                                     errorHandler: @escaping (Error) -> Void)
    
}

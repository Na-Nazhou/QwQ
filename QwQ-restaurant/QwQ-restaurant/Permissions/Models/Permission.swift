//
//  Permissions.swift
//  QwQ-restaurant
//
//  Created by Daniel Wong on 8/4/20.
//

enum Permission: String, Codable {
    case acceptBooking
    case rejectBooking

    case acceptQueue
    case rejectQueue

    case addStaff
    case editProfile

    static var ownerPermissions: [Permission] {
        [Permission.acceptQueue, Permission.acceptBooking, Permission.rejectQueue,
         Permission.rejectBooking, Permission.addStaff, Permission.editProfile]
    }

}

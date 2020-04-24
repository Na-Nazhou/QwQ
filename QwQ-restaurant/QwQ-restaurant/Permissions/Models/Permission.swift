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

    var localizedDescription: String {
        switch self {
        case .acceptBooking:
            return "Accept Booking"
        case .rejectBooking:
            return "Reject Booking"
        case .acceptQueue:
            return "Accept Queue"
        case .rejectQueue:
            return "Reject Queue"
        case .addStaff:
            return "Add Staff"
        case .editProfile:
            return "Edit Profile"
        }
    }

    static var ownerPermissions: [Permission] {
        [Permission.acceptQueue, Permission.acceptBooking, Permission.rejectQueue,
         Permission.rejectBooking, Permission.addStaff, Permission.editProfile]
    }

}

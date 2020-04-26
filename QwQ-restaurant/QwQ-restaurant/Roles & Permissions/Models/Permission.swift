//
//  Permissions.swift
//  QwQ-restaurant
//
//  Created by Daniel Wong on 8/4/20.
//

/// Enumerates a list of the permissions that can be assigned
enum Permission: String, Codable {
    case acceptBooking
    case rejectBooking

    case acceptQueue
    case rejectQueue

    case addStaff
    case editProfile

    /// Used to display/print the permission when needed
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

    /// Defines the permissions that should be allocated to the owner account. Should include all permissions.
    static var ownerPermissions: [Permission] {
        [Permission.acceptQueue, Permission.acceptBooking, Permission.rejectQueue,
         Permission.rejectBooking, Permission.addStaff, Permission.editProfile]
    }

    /// Contains all permissions available in the enumeration
    static var allPermissions: [Permission] {
        return ownerPermissions
    }

}

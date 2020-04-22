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

    static func convertStringArrayToPermissions(_ rawValues: [String]) -> [Permission] {
        var permissions = [Permission]()
        for value in rawValues {
            if let permission = convertStringToPermission(value) {
                permissions.append(permission)
            }
        }
        return permissions
    }

    static func convertStringToPermission(_ rawValue: String) -> Permission? {
        switch rawValue {
        case Permission.acceptBooking.rawValue:
            return Permission.acceptBooking
        case Permission.rejectBooking.rawValue:
            return Permission.rejectBooking
        case Permission.acceptQueue.rawValue:
            return Permission.acceptQueue
        case Permission.rejectQueue.rawValue:
            return Permission.rejectQueue
        case Permission.addStaff.rawValue:
            return Permission.addStaff
        case Permission.editProfile.rawValue:
            return Permission.editProfile
        default:
            return nil
        }
    }

    static func convertPermissionsToStringArray(_ permissions: [Permission]) -> [String] {
        var rawValues = [String]()
        for permission in permissions {
            rawValues.append(permission.rawValue)
        }
        return rawValues
    }
}

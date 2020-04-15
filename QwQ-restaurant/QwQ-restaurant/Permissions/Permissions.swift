//
//  Permissions.swift
//  QwQ-restaurant
//
//  Created by Daniel Wong on 8/4/20.
//

enum Permissions: String {
    case acceptBooking
    case rejectBooking

    case acceptQueue
    case rejectQueue

    case addStaff
    case editProfile

    static func convertStringArrayToPermissions(_ rawValues: [String]) -> [Permissions] {
        var permissions = [Permissions]()
        for value in rawValues {
            if let permission = convertStringToPermission(value) {
                permissions.append(permission)
            }
        }
        return permissions
    }

    static func convertStringToPermission(_ rawValue: String) -> Permissions? {
        switch rawValue {
        case Permissions.acceptBooking.rawValue:
            return Permissions.acceptBooking
        case Permissions.rejectBooking.rawValue:
            return Permissions.rejectBooking
        case Permissions.acceptQueue.rawValue:
            return Permissions.acceptQueue
        case Permissions.rejectQueue.rawValue:
            return Permissions.rejectQueue
        case Permissions.addStaff.rawValue:
            return Permissions.addStaff
        case Permissions.editProfile.rawValue:
            return Permissions.editProfile
        default:
            return nil
        }
    }

    static func convertPermissionsToStringArray(_ permissions: [Permissions]) -> [String] {
        var rawValues = [String]()
        for permission in permissions {
            rawValues.append(permission.rawValue)
        }
        return rawValues
    }
}

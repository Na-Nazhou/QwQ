//
//  ProfileError.swift
//  QwQ-restaurant
//
//  Created by Daniel Wong on 20/3/20.
//

import Foundation

/// Contains the possible errors thrown by Permissions
enum PermissionError: Error {
    case PermissionsNotInitialised
    case NotGrantedPermission
    case PermissionInUse
}

/// Descriptions for each PermissionError
extension PermissionError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .PermissionsNotInitialised:
            return "Your permissions were not initialised properly!"
        case .NotGrantedPermission:
            return "You do not have permission to do so!"
        case .PermissionInUse:
            return "This permission is currently in use by staff!"
        }
    }
}

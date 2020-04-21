//
//  ProfileError.swift
//  QwQ-restaurant
//
//  Created by Daniel Wong on 20/3/20.
//

import Foundation

enum PermissionError: Error {
    case PermissionsNotInitialised
    case NotGrantedPermission
}

extension PermissionError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .PermissionsNotInitialised:
            return "Your permissions were not initialised properly!"
        case .NotGrantedPermission:
            return "You do not have permission to do so!"
        }
    }
}

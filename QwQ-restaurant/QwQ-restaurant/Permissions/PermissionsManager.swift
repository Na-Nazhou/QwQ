//
//  PermissionsManager.swift
//  QwQ-restaurant
//
//  Created by Daniel Wong on 8/4/20.
//

class PermissionsManager {

    static var grantedPermissions: [Permission]?

    static func checkPermissions(_ toCheck: Permission..., handleError: @escaping (Error) -> Void) -> Bool {
        guard let grantedPermissions = grantedPermissions else {
            handleError(ProfileError.PermissionsNotInitialised)
            return false
        }

        for permission in toCheck {
            if !grantedPermissions.contains(permission) {
                return false
            }
        }

        return true
    }
}

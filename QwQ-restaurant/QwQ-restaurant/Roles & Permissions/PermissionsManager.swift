//
//  PermissionsManager.swift
//  QwQ-restaurant
//
//  Created by Daniel Wong on 8/4/20.
//

/// This class facilitates the checking of permissions throughout the application.
class PermissionsManager {

    /// Stores the currently granted permissions of the user
    static var grantedPermissions: [Permission]?

    /// Checks if a particular permission is contained in grantedPermissions
    static func checkPermissions(_ toCheck: Permission...) -> Bool {
        guard let grantedPermissions = grantedPermissions else {
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

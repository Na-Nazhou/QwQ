//
//  PermissionsManager.swift
//  QwQ-restaurant
//
//  Created by Daniel Wong on 8/4/20.
//

class PermissionsManager {

    static var grantedPermissions: [Permission]?

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

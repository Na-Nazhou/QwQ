//
//  PermissionsManager.swift
//  QwQ-restaurant
//
//  Created by Daniel Wong on 8/4/20.
//

class PermissionsManager {

    static var currentStaff: Staff?

    static func checkPermissions(_ permissions: Permissions...) -> Bool {
        guard let staff = currentStaff else {
            return false
        }

        for permission in permissions {
            if !staff.permissions.contains(permission) {
                return false
            }
        }

        return true
    }
}

//
//  Role.swift
//  QwQ-restaurant
//
//  Created by Daniel Wong on 20/4/20.
//

struct Role {
    let roleName: String
    let permissions: [Permission]

    var permissionsStringArray: [String] {
        Permission.convertPermissionsToStringArray(permissions)
    }

    var dictionary: [String: Any] {
        [
            Constants.roleNameKey: roleName,
            Constants.permissionsKey: permissionsStringArray
        ]
    }

    static var defaultRoles: [Role] {
        var roles = [Role]()

        roles.append(Role(roleName: "Owner", permissions: [Permission.acceptBooking, Permission.acceptQueue,
                                                           Permission.rejectBooking, Permission.rejectQueue,
                                                           Permission.addStaff, Permission.editProfile]))
        roles.append(Role(roleName: "Manager", permissions: [Permission.acceptBooking, Permission.acceptQueue,
                                                             Permission.rejectBooking, Permission.rejectQueue,
                                                             Permission.addStaff]))
        roles.append(Role(roleName: "Server", permissions: [Permission.acceptBooking, Permission.acceptQueue,
                                                            Permission.rejectBooking, Permission.rejectQueue]))

        return roles
    }

    init?(dictionary: [String: Any]) {
        guard let permissionAnyArray = dictionary[Constants.permissionsKey] as? [Any] else {
            return nil
        }
        let permissionStringArray = FormattingUtilities.convertAnyToStringArray(permissionAnyArray)
        let permissions = Permission.convertStringArrayToPermissions(permissionStringArray)

        guard let roleName = dictionary[Constants.roleNameKey] as? String else {
            return nil
        }

        self.init(roleName: roleName, permissions: permissions)
    }

    init(roleName: String, permissions: [Permission]) {
        self.roleName = roleName
        self.permissions = permissions
    }

}

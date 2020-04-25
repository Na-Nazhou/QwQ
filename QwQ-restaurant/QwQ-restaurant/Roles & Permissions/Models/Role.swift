//
//  Role.swift
//  QwQ-restaurant
//
//  Created by Daniel Wong on 20/4/20.
//

struct Role: Codable, Equatable {
    let roleName: String
    let permissions: [Permission]

    static var defaultRoles: [Role] {
        var roles = [Role]()

        roles.append(Role(roleName: Constants.ownerPermissionsKey, permissions: [Permission.acceptBooking,
                                                                                 Permission.acceptQueue,
                                                                                 Permission.rejectBooking,
                                                                                 Permission.rejectQueue,
                                                                                 Permission.addStaff,
                                                                                 Permission.editProfile]))
        roles.append(Role(roleName: Constants.managerPermissionsKey, permissions: [Permission.acceptBooking,
                                                                                   Permission.acceptQueue,
                                                                                   Permission.rejectBooking,
                                                                                   Permission.rejectQueue,
                                                                                   Permission.addStaff]))
        roles.append(Role(roleName: Constants.serverPermissionsKey, permissions: [Permission.acceptBooking,
                                                                                  Permission.acceptQueue,
                                                                                  Permission.rejectBooking,
                                                                                  Permission.rejectQueue]))

        return roles
    }

}

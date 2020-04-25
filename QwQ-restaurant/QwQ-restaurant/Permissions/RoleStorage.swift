//
//  RoleStorage.swift
//  QwQ-restaurant
//
//  Created by Daniel Wong on 23/4/20.
//

protocol RoleStorage {

    static var defaultRole: String? { get set }

    static func createDefaultRoles(uid: String, errorHandler: @escaping (Error) -> Void)

    static func getRestaurantRoles(completion: @escaping ([Role]) -> Void,
                                   errorHandler: @escaping (Error) -> Void)

    static func getRolePermissions(roleName: String,
                                   completion: @escaping([Permission]) -> Void,
                                   errorHandler: @escaping (Error) -> Void)

    static func setRestaurantRoles(roles: [Role],
                                   errorHandler: @escaping (Error) -> Void)

    static func deleteRole(role: Role, completion: @escaping (Role) -> Void,
                           errorHandler: @escaping (Error) -> Void)
}

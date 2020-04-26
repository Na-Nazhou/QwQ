//
//  RoleStorage.swift
//  QwQ-restaurant
//
//  Created by Daniel Wong on 23/4/20.
//

/// This protocol specifies the methods that a compatible Role Storage should support.
protocol RoleStorage {

    /// For all of the methods below, the following parameters, if applicable, serve the following purpose:
    /// - Parameters:
    ///     - completion: A closure to be called upon completion of that method
    ///     - errorHandler: A closure that takes an Error type that handles errors

    /// Stores the default Role of the restaurant
    static var defaultRole: String? { get set }

    /// Creates the default Roles for a newly created Restaurant
    /// - Parameters:
    ///     - uid: The UID of the restaurant to create default Roles for
    static func createDefaultRoles(uid: String, errorHandler: @escaping (Error) -> Void)

    /// Retrieves the Roles of the current Restaurant
    static func getRestaurantRoles(completion: @escaping ([Role]) -> Void,
                                   errorHandler: @escaping (Error) -> Void)

    /// Retrieves the permissions associated with a particular Role from the current Restaurant
    /// - Parameters:
    ///     - roleName: The name of the role to retrieve permissions for
    static func getRolePermissions(roleName: String,
                                   completion: @escaping([Permission]) -> Void,
                                   errorHandler: @escaping (Error) -> Void)

    /// Sets the permissions associated for the given Roles
    /// - Parameters:
    ///     - roles: The roles to update permissions for
    static func setRestaurantRoles(roles: [Role],
                                   errorHandler: @escaping (Error) -> Void)

    /// Deletes a role
    /// - Parameters:
    ///     - roles: The roles to be deleted
    static func deleteRole(role: Role, completion: @escaping (Role) -> Void,
                           errorHandler: @escaping (Error) -> Void)
}

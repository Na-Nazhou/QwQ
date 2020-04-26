//
//  LoginLogic.swift
//  QwQ-restaurant
//
//  Created by Daniel Wong on 11/4/20.
//

/// This protocol specifies the methods that a compatible Login Logic should support
protocol LoginLogic {

    /// Stores the delegate for the login logic
    var delegate: LoginLogicDelegate? { get set }

    /// Starts the login process
    /// Needs to perform the following steps:
    ///     1. Calls Authenticator.login to log the user in
    ///     2. Retrieves the Staff object associated with the user with StaffStorage.getStaffInfo
    ///     3. Checks if Staff has been assigned to a Restaurant
    ///         a. If not, calls delegate.noAssignedRestaurant
    ///         b. Aborts login
    ///     4. Sets RestaurantStorage.currentRestaurantUID to the current Restaurant's UID
    ///     5. Retrives the Restaurant object associated with the Staff with RestaurantStorage.getRestaurantInfo
    ///     6. Sets RoleStorage.defaultRole to the restaurant's default role, initialises RestaurantPostLoginSetupManager with Restaurant
    ///     7. Checks if Staff has a Role
    ///         a. Else, calls delegate.noAssignedRole
    ///         b. Aborts login
    ///     8. Retrieves permissions assigned to that role
    ///     9. Sets PermissionsManager.assignedPermissions to retreived permissions
    func beginLogin(authDetails: AuthDetails)

    /// Starts the above-mentioned process at Step 2 instead, skipping the login process.
    /// Used when there is an existing login from the previous session.
    func getStaffInfo()
}

//
//  SignupLogic.swift
//  QwQ-restaurant
//
//  Created by Daniel Wong on 11/4/20.
//

/// This protocol specifies the methods that a compatible Signup Logic should support
protocol SignupLogic {

    /// Stores the delegate for the signup logic
    var delegate: SignupLogicDelegate? { get set }

    /// Starts the signup process
    /// Needs to perform the following steps:
    ///     1. Calls Authenticator.signup to create new account
    ///     2. If the new account is an owner's account:
    ///         a. Creates new Restaurant profile with RestaurantStorage.createInitialRestaurantProfile
    ///         b. Sets RestaurantStorage.currentRestaurantUID to newly created Restaurant's UID
    ///         c. Creates new Staff profile with StaffStorage.createIntialStaffProfile
    ///         d. Sets StaffStorage.currentStaffUID to newly created Staff's UID
    ///         e. Create default roles for Restaurant with RoleStorage.createDefaultRoles
    ///         f. Set granted permissions to Permission.ownerPermissions
    ///     3. If the new account is a staff's account:
    ///         c. Creates new Staff profile with StaffStorage.createIntialStaffProfile
    ///         d. Sets StaffStorage.currentStaffUID to newly created Staff's UID
    ///     4. Sign in the user after signup with Authenticator.login
    func beginSignup()
    
}

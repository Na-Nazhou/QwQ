//
//  FIRLoginLogic.swift
//  QwQ-restaurant
//
//  Created by Daniel Wong on 11/4/20.
//

class FIRLoginLogic: LoginLogic {

    typealias Auth = FIRAuthenticator
    typealias StaffProfile = FIRStaffStorage
    typealias RestaurantProfile = FIRRestaurantStorage
    typealias RoleStorage = FIRRoleStorage

    weak var delegate: LoginLogicDelegate?

    func beginLogin(authDetails: AuthDetails) {
        Auth.login(authDetails: authDetails, completion: getStaffInfo, errorHandler: handleError(error:))

        /* Email verification code - to be enabled only in production application
        guard Auth.checkIfEmailVerified() else {
            Auth.sendVerificationEmail(errorHandler: handleError(error:))
            delegate?.emailNotVerified()
            return
        }
        */
    }

    func getStaffInfo() {
        StaffProfile.getStaffInfo(completion: getAssignedRestaurant(staff:), errorHandler: handleError(error:))
    }

    private func getAssignedRestaurant(staff: Staff) {
        guard let assignedRestaurant = staff.assignedRestaurant else {
            delegate?.noAssignedRestaurant()
            abortLogin()
            return
        }

        RestaurantProfile.currentRestaurantUID = assignedRestaurant

        getAssignedPermissions(staff: staff)

        RestaurantProfile.getRestaurantInfo(completion: getRestaurantInfoComplete(restaurant:),
                                            errorHandler: handleError(error:))

    }

    private func getAssignedPermissions(staff: Staff) {
        guard let assignedRole = staff.roleName else {
            delegate?.noAssignedRole()
            abortLogin()
            return
        }

        RoleStorage.getRolePermissions(roleName: assignedRole,
                                       completion: getAssignedPermissionsComplete(permissions:),
                                       errorHandler: handleError(error:))
    }

    private func getAssignedPermissionsComplete(permissions: [Permission]) {
        PermissionsManager.grantedPermissions = permissions
    }

    private func getRestaurantInfoComplete(restaurant: Restaurant) {
        RestaurantPostLoginSetupManager.setUp(asIdentity: restaurant)
        delegate?.loginComplete()
    }

    private func abortLogin() {
        Auth.logout(completion: {}, errorHandler: handleError(error:))
    }

    private func handleError(error: Error) {
        delegate?.handleError(error: error)
    }
}

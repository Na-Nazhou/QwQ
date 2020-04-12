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
        if staff.assignedRestaurant.isEmpty {
            fatalError("Testing.")
            // to do: Segue to no assigned restaurant page.
        } else {
            RestaurantProfile.currentRestaurantUID = staff.assignedRestaurant
            RestaurantProfile.getRestaurantInfo(completion: getRestaurantInfoComplete(restaurant:),
                                                errorHandler: handleError(error:))
        }
    }

    private func getRestaurantInfoComplete(restaurant: Restaurant) {
        RestaurantPostLoginSetupManager.setUp(asIdentity: restaurant)
        delegate?.loginComplete()
    }

    private func handleError(error: Error) {
        delegate?.handleError(error: error)
    }
}

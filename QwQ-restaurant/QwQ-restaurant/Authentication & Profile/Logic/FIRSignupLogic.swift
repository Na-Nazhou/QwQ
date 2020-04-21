//
//  SignupLogicManager.swift
//  QwQ-restaurant
//
//  Created by Daniel Wong on 11/4/20.
//

class FIRSignupLogic: SignupLogic {

    typealias Auth = FIRAuthenticator
    typealias StaffProfile = FIRStaffStorage
    typealias RestaurantProfile = FIRRestaurantStorage
    typealias RoleStorage = FIRRoleStorage
    
    weak var delegate: SignupLogicDelegate?

    private let authDetails: AuthDetails
    private let signupDetails: SignupDetails
    private let userType: UserType

    private var isOwner: Bool {
        userType == UserType.restaurant
    }

    init(authDetails: AuthDetails, signupDetails: SignupDetails, userType: UserType) {
        self.authDetails = authDetails
        self.signupDetails = signupDetails
        self.userType = userType
    }

    func beginSignup() {
        Auth.signup(signupDetails: signupDetails,
                    authDetails: authDetails,
                    completion: createProfiles(uid:),
                    errorHandler: handleError(error:))
    }

    private func createProfiles(uid: String) {
        if isOwner {
            RestaurantProfile.createInitialRestaurantProfile(uid: uid,
                                                             signupDetails: signupDetails,
                                                             email: authDetails.email,
                                                             errorHandler: handleError(error:))
            RestaurantProfile.currentRestaurantUID = uid

            StaffProfile.createInitialStaffProfile(uid: authDetails.email,
                                                   signupDetails: signupDetails,
                                                   email: authDetails.email,
                                                   assignedRestaurant: uid,
                                                   errorHandler: handleError(error:))
            StaffProfile.currentStaffUID = authDetails.email

            RoleStorage.createDefaultRoles(uid: uid, errorHandler: handleError(error:))
            PermissionsManager.grantedPermissions = Permission.ownerPermissions

        } else {
            StaffProfile.createInitialStaffProfile(uid: authDetails.email,
                                                   signupDetails: signupDetails,
                                                   email: authDetails.email,
                                                   errorHandler: handleError(error:))
            StaffProfile.currentStaffUID = authDetails.email
        }

        FIRAuthenticator.login(authDetails: authDetails,
                               completion: complete,
                               errorHandler: handleError(error:))
    }

    private func complete() {
        delegate?.signUpComplete()
    }

    private func handleError(error: Error) {
        delegate?.handleError(error: error)
    }
}

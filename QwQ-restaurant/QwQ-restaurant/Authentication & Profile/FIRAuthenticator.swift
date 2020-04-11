//
//  FBAuthenticator.swift
//  QwQ-restaurant
//
//  Created by Daniel Wong on 15/3/20.
//

import FirebaseAuth
import FirebaseFirestore

class FIRAuthenticator: Authenticator {

    typealias StaffProfile = FIRStaffStorage
    typealias RestaurantProfile = FIRRestaurantStorage
    
    static func signup(signupDetails: SignupDetails,
                       authDetails: AuthDetails,
                       completion: @escaping (String) -> Void,
                       errorHandler: @escaping (Error) -> Void) {
        
        Auth.auth().createUser(withEmail: authDetails.email, password: authDetails.password) { (result, error) in
            if let error = error {
                errorHandler(error)
                return
            }
            guard let result = result else {
                return
            }

            completion(result.user.uid)
        }
    }
    
    static func login(authDetails: AuthDetails,
                      completion: @escaping () -> Void,
                      errorHandler: @escaping (Error) -> Void) {
        
        Auth.auth().signIn(withEmail: authDetails.email, password: authDetails.password) { (_, error) in
            if let error = error {
                errorHandler(error)
                return
            }
            StaffProfile.currentStaffUID = authDetails.email
            completion()
        }
    }
    
    static func logout(completion: @escaping () -> Void, errorHandler: @escaping (Error) -> Void) {
        do {
            try Auth.auth().signOut()
            StaffProfile.currentStaffUID = nil
            RestaurantProfile.currentRestaurantUID = nil
            completion()
        } catch {
            errorHandler(AuthError.SignOutError)
        }
    }

    static func changePassword(_ password: String, errorHandler: @escaping (Error) -> Void) {
        Auth.auth().currentUser?.updatePassword(to: password, completion: { (error) in
            if let error = error {
                errorHandler(error)
            }
        })
    }

    static func sendVerificationEmail(errorHandler: @escaping (Error) -> Void) {
        guard let user = Auth.auth().currentUser else {
            errorHandler(AuthError.NotSignedIn)
            return
        }
        user.sendEmailVerification { (error) in
            if let error = error {
                errorHandler(error)
            }
        }
    }

    static func checkIfEmailVerified() -> Bool {
        guard let user = Auth.auth().currentUser else {
            return false
        }
        return user.isEmailVerified
    }

    static func checkIfAlreadyLoggedIn() -> Bool {
        return Auth.auth().currentUser != nil
    }

    static func initAlreadyLoggedInUser() {
        guard let user = Auth.auth().currentUser else {
            return
        }
        StaffProfile.currentStaffUID = user.email
    }

    static func resetPassword(for email: String,
                              completion: @escaping () -> Void,
                              errorHandler: @escaping (Error) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            if let error = error {
                errorHandler(error)
            }
            completion()
        }
    }
}

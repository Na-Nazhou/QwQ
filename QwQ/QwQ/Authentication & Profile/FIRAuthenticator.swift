//
//  FIRAuthenticator.swift
//  QwQ
//
//  Created by Daniel Wong on 11/3/20.
//

import FirebaseAuth

class FIRAuthenticator: Authenticator {

    typealias Profile = FIRProfileStorage

    static func signup(signupDetails: SignupDetails,
                       authDetails: AuthDetails,
                       completion: @escaping () -> Void,
                       errorHandler: @escaping (Error) -> Void) {
        Auth.auth().createUser(withEmail: authDetails.email, password: authDetails.password) { (result, error) in
            if let error = error {
                errorHandler(error)
                return
            }
            guard let result = result else {
                errorHandler(AuthError.AuthResultError)
                return
            }
            Profile.createInitialCustomerProfile(uid: result.user.uid,
                                                 signupDetails: signupDetails,
                                                 authDetails: authDetails,
                                                 errorHandler: errorHandler)
            FIRAuthenticator.login(authDetails: authDetails,
                                   completion: completion,
                                   errorHandler: errorHandler)
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
            Profile.currentUID = authDetails.email
            Profile.currentAuthType = AuthTypes.Firebase
            completion()
        }
    }

    static func logout(completion: @escaping () -> Void, errorHandler: @escaping (Error) -> Void) {
        do {
            try Auth.auth().signOut()
            Profile.currentUID = nil
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
        guard let user = Auth.auth().currentUser else {
            return false
        }
        Profile.currentUID = user.email
        Profile.currentAuthType = AuthTypes.Firebase
        return true
    }

}

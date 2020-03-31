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
            guard result != nil else {
                errorHandler(AuthError.AuthResultError)
                return
            }
            Profile.createInitialCustomerProfile(uid: authDetails.email,
                                                 signupDetails: signupDetails,
                                                 authDetails: authDetails,
                                                 errorHandler: errorHandler)

            /* Email verification code, to be enabled only for production.
            FIRAuthenticator.login(authDetails: authDetails, completion: {
                guard let user = Auth.auth().currentUser else {
                    errorHandler(AuthError.AuthResultError)
                    return
                }
                user.sendEmailVerification { (error) in
                    if let error = error {
                        errorHandler(error)
                    }
                }
                FIRAuthenticator.logout(completion: completion, errorHandler: errorHandler)
            }, errorHandler: errorHandler)
            */
            completion()
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

    static func resetPassword(for email: String,
                              completion: @escaping () -> Void,
                              errorHandler: @escaping (Error) -> Void) {
        Auth.auth().sendPasswordReset(withEmail: email) { (error) in
            if let error = error {
                errorHandler(error)
            }
        }
    }

}

//
//  FBAuthenticator.swift
//  QwQ
//
//  Created by Daniel Wong on 11/3/20.
//

import FirebaseAuth

class FBAuthenticator: Authenticator {

    typealias Profile = FBProfileStorage

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
            FBAuthenticator.login(authDetails: authDetails,
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
            completion()
        }
    }

    static func logout(completion: @escaping () -> Void, errorHandler: @escaping (Error) -> Void) {
        do {
            try Auth.auth().signOut()
            completion()
        } catch {
            errorHandler(AuthError.SignOutError)
        }
    }

    static func checkIfAlreadyLoggedIn(completion: @escaping () -> Void, failure: @escaping () -> Void) {
        if Auth.auth().currentUser != nil {
            completion()
        } else {
            failure()
        }
    }

    static func getUIDOfCurrentUser() -> String? {
        Auth.auth().currentUser?.uid
    }

}

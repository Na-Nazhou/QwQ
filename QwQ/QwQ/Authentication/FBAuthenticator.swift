//
//  FBAuthenticator.swift
//  QwQ
//
//  Created by Daniel Wong on 11/3/20.
//

import FirebaseAuth
import FirebaseFirestore

class FBAuthenticator: Authenticator {

    func signup(name: String, email: String, password: String) throws -> String {
        var signupError: Error?
        var signupResult: AuthDataResult?

        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let error = error {
                signupError = error
            }
            if let result = result {
                signupResult = result
            }
        }

        if let error = signupError {
            throw SignupError.firebaseError(error: error.localizedDescription)
        }

        if let result = signupResult {
            createUserInfo(name: name, email: email, uid: result.user.uid)
            return result.user.uid
        } else {
            throw SignupError.firebaseError(error: "Something went wrong.")
        }

    }

    func login(email: String, password: String) throws -> String {
        var loginError: Error?
        var loginResult: AuthDataResult?

        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                print("error")
                loginError = error
            }
            if let result = result {
                print("result")
                loginResult = result
            }
        }

        if let error = loginError {
            throw LoginError.firebaseError(error: error.localizedDescription)
        }
        if let result = loginResult {
            return result.user.uid
        } else {
            throw LoginError.firebaseError(error: "Something went wrong.")
        }
    }

    private func createUserInfo(name: String, email: String, uid: String) {
        let db = Firestore.firestore()
        db.collection("customers").addDocument(data: ["name": name, "email:": email, "id": uid]) { (error) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }

}

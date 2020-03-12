//
//  FBAuthenticator.swift
//  QwQ
//
//  Created by Daniel Wong on 11/3/20.
//

import FirebaseAuth
import FirebaseFirestore

class FBAuthenticator {

    func signup(name: String, email: String, password: String) {
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let result = result {
                print("login success! \(result.user.uid)")
                self.createUserInfo(name: name, email: email, uid: result.user.uid)
            }
        }
    }

    func login(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let result = result {
                print("login success! \(result.user.uid)")
            }
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

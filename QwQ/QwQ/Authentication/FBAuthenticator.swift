//
//  FBAuthenticator.swift
//  QwQ
//
//  Created by Daniel Wong on 11/3/20.
//

import FirebaseAuth
import FirebaseFirestore

class FBAuthenticator: Authenticator {

    private weak var view: AuthDelegate?

    func setView(view: AuthDelegate) {
        self.view = view
    }

    func signup(name: String, contact: String, email: String, password: String) {

        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let error = error {
                self.view?.showMessage(title: "Error:", message: error.localizedDescription, buttonText: "Okay")
                return
            }
            guard let result = result else {
                return
            }

            self.createUserInfo(name: name, contact: contact, email: email, uid: result.user.uid)
            self.login(email: email, password: password)
        }
    }

    func login(email: String, password: String) {

        Auth.auth().signIn(withEmail: email, password: password) { (_, error) in
            if let error = error {
                self.view?.showMessage(title: "Error:", message: error.localizedDescription, buttonText: "Okay")
                return
            }

            self.view?.authSucceeded()
        }
    }

    private func createUserInfo(name: String, contact: String, email: String, uid: String) {
        let db = Firestore.firestore()
        db.collection("customers")
            .addDocument(data: ["name": name, "contact": contact, "email": email, "uid": uid]) { (error) in
            if let error = error {
                self.view?.showMessage(title: "Error", message: error.localizedDescription, buttonText: "Okay")
            }
            }
    }

}

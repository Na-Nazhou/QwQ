//
//  FBAuthenticator.swift
//  QwQ-restaurant
//
//  Created by Daniel Wong on 15/3/20.
//

import FirebaseAuth
import FirebaseFirestore

class FBAuthenticator: Authenticator {

    private weak var delegate: AuthDelegate?

    func setDelegate(delegate: AuthDelegate) {
        self.delegate = delegate
    }

    func signup(name: String, contact: String, email: String, password: String) {

        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let error = error {
                self.delegate?.showMessage(title: "Error:",
                                           message: error.localizedDescription,
                                           buttonText: "Okay",
                                           buttonAction: nil)
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
                self.delegate?.showMessage(title: "Error:",
                                           message: error.localizedDescription,
                                           buttonText: "Okay",
                                           buttonAction: nil)
                return
            }

            self.delegate?.authCompleted()
        }
    }

    func logout() {
        do {
            try Auth.auth().signOut()
            delegate?.authCompleted()
        } catch {
            delegate?.showMessage(title: "Error",
                                  message: "A logout error occured.",
                                  buttonText: "Okay",
                                  buttonAction: nil)
        }
    }

    func checkIfAlreadyLoggedIn() {
        if Auth.auth().currentUser != nil {
            delegate?.authCompleted()
        }
    }

    private func createUserInfo(name: String, contact: String, email: String, uid: String) {
        let db = Firestore.firestore()
        db.collection("restaurants")
            .document(uid)
            .setData(["uid": uid, "name": name, "contact": contact, "email": email]) { (error) in
            if let error = error {
                self.delegate?.showMessage(title: "Error",
                                           message: error.localizedDescription,
                                           buttonText: "Okay",
                                           buttonAction: nil)
            }
            }
    }

}

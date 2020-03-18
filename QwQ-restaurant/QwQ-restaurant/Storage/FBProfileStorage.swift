//
//  FBProfileStorage.swift
//  QwQ-restaurant
//
//  Created by Daniel Wong on 18/3/20.
//

import FirebaseAuth
import FirebaseFirestore

class FBProfileStorage: ProfileStorage {

    private weak var delegate: ProfileDelegate?

    func setDelegate(delegate: ProfileDelegate) {
        self.delegate = delegate
    }

    func getRestaurantInfo() {
        let db = Firestore.firestore()
        guard let user = Auth.auth().currentUser else {
            return
        }
        let docRef = db.collection("restaurants").document(user.uid)

        docRef.getDocument { (document, error) in
            if let error = error {
                self.delegate?.showMessage(title: "Error!",
                                           message: error.localizedDescription,
                                           buttonText: "Okay",
                                           buttonAction: nil)
            }
            if let data = document?.data() {
                print(data)
                guard let restaurant = Restaurant(dictionary: data) else {
                    self.delegate?.showMessage(title: "Error!",
                                               message: "A fatal error occured.",
                                               buttonText: "Okay",
                                               buttonAction: nil)
                    return
                }
                self.delegate?.getRestaurantInfoComplete(restaurant: restaurant)
            }
        }
    }

    func updateRestaurantInfo(restaurant: Restaurant) {
        let db = Firestore.firestore()
        guard let user = Auth.auth().currentUser else {
            return
        }
        let docRef = db.collection("restaurants").document(user.uid)

        docRef.updateData(restaurant.dictionary) { (error) in
            if let error = error {
                self.delegate?.showMessage(title: "Error:",
                                           message: error.localizedDescription,
                                           buttonText: "Okay",
                                           buttonAction: nil)
                return
            }
            self.delegate?.updateComplete()
        }
    }
}

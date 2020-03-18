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
        let docRef = db.collection("customers").document(user.uid)

        docRef.getDocument { (document, error) in
            if let error = error {
                self.delegate?.showMessage(title: "Error!", message: error.localizedDescription, buttonText: "Okay")
            }
            if let data = document?.data() {
                guard let customer = Customer(dictionary: data) else {
                    self.delegate?.showMessage(title: "Error!", message: "A fatal error occured.", buttonText: "Okay")
                    return
                }
                self.delegate?.getCustomerInfoComplete(customer: customer)
            }
        }
    }

    func updateRestaurantInfo(restaurant: Restaurant) {
        let db = Firestore.firestore()
        guard let user = Auth.auth().currentUser else {
            return
        }
        let docRef = db.collection("restaurant").document(user.uid)

        docRef.updateData(restaurant.dictionary) { (error) in
            if let error = error {
                self.delegate?.showMessage(title: "Error:", message: error.localizedDescription, buttonText: "Okay")
                return
            }
            self.delegate?.updateComplete()
        }
    }
}

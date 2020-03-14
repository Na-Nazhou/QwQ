//
//  FBProfileStorage.swift
//  QwQ
//
//  Created by Daniel Wong on 14/3/20.
//

import FirebaseAuth
import FirebaseFirestore

class FBProfileStorage: ProfileStorage {

    let uid: String
    let customers: CollectionReference

    init() {
        guard let user = Auth.auth().currentUser else {
            return
        }
        self.uid = user.uid
        self.db = Firestore.firestore().collection("customers").document()
    }

    func getCustomer() -> Customer {

    }

    func updateCustomer(customer: Customer) {
        <#code#>
    }
    
}

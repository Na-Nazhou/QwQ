//
//  FIRCustomerStorage.swift
//  QwQ-restaurant
//
//  Created by Daniel Wong on 19/3/20.
//

import FirebaseFirestore

class FIRCustomerStorage: CustomerStorage {
    static func getCustomerFromUID(uid: String,
                                   completion: @escaping (Customer) -> Void,
                                   errorHandler: ((Error) -> Void)?) {

        let db = Firestore.firestore()
        let docRef = db.collection(Constants.customersDirectory).document(uid)

        docRef.getDocument { (document, error) in
            if let error = error, let errorHandler = errorHandler {
                errorHandler(error)
            }
            if let data = document?.data() {
                guard let customer = Customer(dictionary: data) else {
                    // create new error for error handler?
                    return
                }
                completion(customer)
            }
        }
    }
}

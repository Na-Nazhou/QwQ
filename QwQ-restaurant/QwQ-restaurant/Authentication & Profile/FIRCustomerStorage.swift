//
//  FIRCustomerStorage.swift
//  QwQ-restaurant
//
//  Created by Daniel Wong on 19/3/20.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import os

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

            let result = Result {
              try document?.data(as: Customer.self)
            }
            switch result {
            case .success(let cus):
                if let customer = cus {
                    completion(customer)
                    return
                }
                os_log("Customer document does not exist.", log: Log.createCustomerError, type: .error)
            case .failure(let error):
                os_log("Customer cannot be created.",
                       log: Log.createCustomerError, type: .error, error.localizedDescription)
            }
        }
    }
}

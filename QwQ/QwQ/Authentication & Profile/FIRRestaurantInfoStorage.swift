//
//  FIRRestaurantInfoStorage.swift
//  QwQ
//
//  Created by Daniel Wong on 19/3/20.
//

import FirebaseFirestore
import os

class FIRRestaurantInfoStorage: RestaurantInfoStorage {

    static func getRestaurantFromUID(uid: String,
                                     completion: @escaping (Restaurant) -> Void,
                                     errorHandler: ((Error) -> Void)?) {

        let db = Firestore.firestore()
        let docRef = db.collection(Constants.restaurantsDirectory).document(uid)

        docRef.getDocument { (document, error) in
            if let error = error, let errorHandler = errorHandler {
                errorHandler(error)
            }
            let result = Result {
              try document?.data(as: Restaurant.self)
            }
            switch result {
            case .success(let res):
                if let restaurant = res {
                    completion(restaurant)
                    return
                }
                os_log("Restaurant document does not exist.", log: Log.createRestaurantError, type: .error)
            case .failure(let error):
                os_log("Restaurant cannot be created.",
                       log: Log.createRestaurantError, type: .error, error.localizedDescription)
            }
        }
    }

}

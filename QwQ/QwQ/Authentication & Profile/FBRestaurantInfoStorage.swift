//
//  FBRestaurantInfoStorage.swift
//  QwQ
//
//  Created by Daniel Wong on 19/3/20.
//

import FirebaseFirestore

class FBRestaurantInfoStorage: RestaurantInfoStorage {

    static func getRestaurantFromUID(uid: String,
                                     completion: @escaping (Restaurant) -> Void,
                                     errorHandler: ((Error) -> Void)?) {
        let db = Firestore.firestore()

        let docRef = db.collection(Constants.restaurantsDirectory).document(uid)

        docRef.getDocument { (document, error) in
            if let error = error, let errorHandler = errorHandler {
                errorHandler(error)
            }
            if let data = document?.data() {
                guard let restaurant = Restaurant(dictionary: data) else {
                    // create new error for error handler?
                    return
                }
                completion(restaurant)
            }
        }
    }

}

//
//  FIRStaffPositionStorage.swift
//  QwQ-restaurant
//
//  Created by Daniel Wong on 23/4/20.
//

import FirebaseFirestore
import os

class FIRStaffPositionStorage {

    typealias RestaurantProfile = FIRRestaurantStorage

    static let dbRef = Firestore.firestore().collection(Constants.staffDirectory)

    static func getAllRestaurantStaff(completion: @escaping ([StaffPosition]) -> Void,
                                      errorHandler: @escaping (Error) -> Void) {
        guard let restaurantUID = RestaurantProfile.currentRestaurantUID else {
            errorHandler(ProfileError.InvalidRestaurant)
            return
        }

        dbRef.whereField(Constants.assignedRestaurantKey, isEqualTo: restaurantUID)
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    errorHandler(error)
                    return
                }

                var staff = [StaffPosition]()

                for document in querySnapshot!.documents {
                    print(document.data())
                    let result = Result {
                        try document.data(as: StaffPosition.self)
                    }
                    switch result {
                    case .success(let newStaff):
                        if let newStaff = newStaff {
                            staff.append(newStaff)
                        }
                    case .failure(let error):
                        os_log("Error creating position.",
                               log: Log.createStaffError,
                               type: .error, error.localizedDescription)
                    }
                }

                completion(staff)
            }
    }
}

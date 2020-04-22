//
//  FIRStaffStorage.swift
//  QwQ-restaurant
//
//  Created by Daniel Wong on 9/4/20.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
import os

class FIRStaffStorage: StaffStorage {

    typealias Auth = FIRAuthenticator
    typealias RestaurantProfile = FIRRestaurantStorage

    static var currentStaffUID: String?

    static let dbRef = Firestore.firestore().collection(Constants.staffDirectory)

    /// Create initial staff profile for non-owner staff
    static func createInitialStaffProfile(uid: String,
                                          signupDetails: SignupDetails,
                                          email: String,
                                          errorHandler: @escaping (Error) -> Void) {

        let docRef = dbRef.document(uid)
        do {
            try docRef.setData(from:
                Staff(uid: uid, name: signupDetails.name,
                      email: email, contact: signupDetails.contact),
                           merge: true) { (error) in
                if let error = error {
                    errorHandler(error)
                }
            }
        } catch {
            errorHandler(error)
        }
    }

    /// Create initial staff profile for owner
    static func createInitialStaffProfile(uid: String,
                                          signupDetails: SignupDetails,
                                          email: String,
                                          assignedRestaurant: String,
                                          errorHandler: @escaping (Error) -> Void) {

        let docRef = dbRef.document(uid)
        do {
            try docRef.setData(from:
                Staff(uid: uid, name: signupDetails.name,
                      email: email, contact: signupDetails.contact,
                      assignedRestaurant: assignedRestaurant,
                      roleName: Constants.ownerPermissionsKey)) { (error) in
                if let error = error {
                    errorHandler(error)
                }
            }
        } catch {
            errorHandler(error)
        }
    }

    static func getStaffInfo(completion: @escaping (Staff) -> Void,
                             errorHandler: @escaping (Error) -> Void) {

        guard let uid = currentStaffUID else {
            errorHandler(ProfileError.NotSignedIn)
            return
        }

        let docRef = dbRef.document(uid)

        docRef.getDocument { (document, error) in
            if let error = error {
                errorHandler(error)
                return
            }

            let result = Result {
                try document?.data(as: Staff.self)
            }
            switch result {
            case .success(let staff):
                if let staff = staff {
                    completion(staff)
                    return
                }
                os_log("Staff document not found.", log: Log.createStaffError, type: .error)
            case .failure(let error):
                os_log("Error creating staff.", log: Log.createStaffError, type: .error, error.localizedDescription)
            }

            /// If no staff profile is found, the user is not a staff (probably a customer)
            errorHandler(ProfileError.IncorrectUserType)
            Auth.logout(completion: {}, errorHandler: errorHandler)
        }
    }

    static func updateStaffInfo(staff: Staff,
                                completion: @escaping () -> Void,
                                errorHandler: @escaping (Error) -> Void) {

        guard let uid = currentStaffUID else {
            errorHandler(ProfileError.NotSignedIn)
            return
        }
        let docRef = dbRef.document(uid)

        do {
            try docRef.setData(from: staff) { (error) in
                if let error = error {
                    errorHandler(error)
                    return
                }
                completion()
            }
        } catch {
            errorHandler(error)
        }
    }

    static func getAllRestaurantStaff(completion: @escaping ([Staff]) -> Void,
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

                var staff = [Staff]()

                for document in querySnapshot!.documents {
                    let result = Result {
                        try document.data(as: Staff.self)
                    }
                    switch result {
                    case .success(let newStaff):
                        if let newStaff = newStaff {
                            staff.append(newStaff)
                        }
                    case .failure(let error):
                        os_log("Error creating staff.",
                               log: Log.createStaffError,
                               type: .error, error.localizedDescription)
                    }
                }

                completion(staff)
            }
    }
}

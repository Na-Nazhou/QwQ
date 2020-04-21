//
//  FIRStaffStorage.swift
//  QwQ-restaurant
//
//  Created by Daniel Wong on 9/4/20.
//

import FirebaseFirestore

class FIRStaffStorage: StaffStorage {

    typealias Auth = FIRAuthenticator

    static var currentStaffUID: String?

    static let dbRef = Firestore.firestore().collection(Constants.staffDirectory)

    /// Create initial staff profile for non-owner staff
    static func createInitialStaffProfile(uid: String,
                                          signupDetails: SignupDetails,
                                          email: String,
                                          errorHandler: @escaping (Error) -> Void) {

        let docRef = dbRef.document(uid)
        docRef.setData([Constants.uidKey: uid,
                        Constants.nameKey: signupDetails.name,
                        Constants.emailKey: email,
                        Constants.contactKey: signupDetails.contact], merge: true) { (error) in
            if let error = error {
                errorHandler(error)
            }
        }
    }

    /// Create initial staff profile for owner
    static func createInitialStaffProfile(uid: String,
                                          signupDetails: SignupDetails,
                                          email: String,
                                          assignedRestaurant: String,
                                          errorHandler: @escaping (Error) -> Void) {

        let docRef = dbRef.document(uid)
        docRef.setData([Constants.uidKey: uid,
                        Constants.nameKey: signupDetails.name,
                        Constants.emailKey: email,
                        Constants.contactKey: signupDetails.contact,
                        Constants.assignedRestaurantKey: assignedRestaurant,
                        Constants.roleNameKey: "Owner"]) { (error) in
            if let error = error {
                errorHandler(error)
            }
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

            if let data = document?.data() {
                if let staff = Staff(dictionary: data) {
                    completion(staff)
                    return
                }
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

        docRef.updateData(staff.dictionary) { (error) in
            if let error = error {
                errorHandler(error)
                return
            }
            completion()
        }
    }
}

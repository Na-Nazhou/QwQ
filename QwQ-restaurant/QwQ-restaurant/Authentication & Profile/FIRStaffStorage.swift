//
//  FIRStaffStorage.swift
//  QwQ-restaurant
//
//  Created by Daniel Wong on 9/4/20.
//

import FirebaseFirestore

class FIRStaffStorage: StaffStorage {

    typealias Auth = FIRAuthenticator

    static let dbRef = Firestore.firestore().collection(Constants.staffDirectory)

    static func createInitialStaffProfile(uid: String,
                                          signupDetails: SignupDetails,
                                          email: String,
                                          isOwner: Bool,
                                          errorHandler: @escaping (Error) -> Void) {

        let docRef = dbRef.document(uid)
        docRef.setData([Constants.uidKey: uid,
                        Constants.nameKey: signupDetails.name,
                        Constants.emailKey: email,
                        Constants.contactKey: signupDetails.contact,
                        Constants.assignedRestaurantKey: "",
                        Constants.isOwnerKey: isOwner,
                        Constants.permissionsKey: ""]) { (error) in
            if let error = error {
                errorHandler(error)
            }
        }
    }

    static func getStaffInfo(completion: @escaping (Staff) -> Void,
                             errorHandler: @escaping (Error) -> Void) {

        guard let uid = Auth.getUIDOfCurrentUser() else {
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

        guard let uid = Auth.getUIDOfCurrentUser() else {
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

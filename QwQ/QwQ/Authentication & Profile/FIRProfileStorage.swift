//
//  FIRProfileStorage.swift
//  QwQ
//
//  Created by Daniel Wong on 14/3/20.
//
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage
import FirebaseUI
import os
import SDWebImage

class FIRProfileStorage: ProfileStorage {

    typealias Auth = FIRAuthenticator

    static var currentUID: String?
    static var currentAuthType: AuthTypes?

    static let dbRef = Firestore.firestore().collection(Constants.customersDirectory)
    static let storageRef = Storage.storage().reference().child("profile-pics")

    static func createInitialCustomerProfile(uid: String,
                                             signupDetails: SignupDetails,
                                             email: String,
                                             errorHandler: @escaping (Error) -> Void) {
        let db = Firestore.firestore()
        do {
            try db.collection(Constants.customersDirectory)
                .document(uid)
                .setData(from: Customer(uid: uid, name: signupDetails.name,
                                        email: email, contact: signupDetails.contact)
                ) { (error) in
                    if let error = error {
                        errorHandler(error)
                    }
                }
        } catch {
            os_log("Error serializing customer to write to firestore.",
                   log: Log.entityError,
                   type: .error,
                   error.localizedDescription)
        }
    }

    static func getCustomerInfo(completion: @escaping (Customer) -> Void,
                                errorHandler: @escaping (Error) -> Void) {
        guard let uid = currentUID else {
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
                try document?.data(as: Customer.self)
            }
            switch result {
            case .success(let customer):
                if let customer = customer {
                    completion(customer)
                    return
                }
                print("Customer document does not exist")
            case .failure(let error):
                print("Error decoding customer: \(error)")
            }

            errorHandler(ProfileError.UserProfileNotFound)
            Auth.logout(completion: {}, errorHandler: errorHandler)
        }
    }

    static func getCustomerProfilePic(uid: String,
                                      placeholder imageView: UIImageView) {
        let reference = storageRef.child("\(uid).png")
        guard let image = imageView.image else {
            return
        }
        imageView.checkCacheThenSetImage(with: reference, placeholder: image)
    }

    static func updateCustomerInfo(customer: Customer,
                                   completion: @escaping () -> Void,
                                   errorHandler: @escaping (Error) -> Void) {
        guard let uid = currentUID else {
            errorHandler(ProfileError.NotSignedIn)
            return
        }
        let docRef = dbRef.document(uid)

        do {
            try docRef.setData(from: customer) { (error) in
                if let error = error {
                    errorHandler(error)
                    return
                }
                CustomerPostLoginSetupManager.customerDidUpdateProfile(updated: customer)
                completion()
            }
        } catch {
            os_log("Error serializing customer to write to firestore.",
                   log: Log.entityError,
                   type: .error,
                   error.localizedDescription)
        }
    }

    static func updateCustomerProfilePic(uid: String,
                                         image: UIImage,
                                         errorHandler: @escaping (Error) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            errorHandler(ProfileError.NoImageSelected)
            return
        }
        storageRef.child("\(uid).png").putData(imageData, metadata: nil) { (_, error) in
            if let error = error {
                errorHandler(error)
                return
            }
        }
        SDImageCache.shared.removeImage(forKey: storageRef.child("\(uid).png").fullPath, withCompletion: nil)
    }

}

//
//  FBProfileStorage.swift
//  QwQ
//
//  Created by Daniel Wong on 14/3/20.
//

import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import FirebaseUI
import SDWebImage

class FBProfileStorage: ProfileStorage {

    static let dbRef = Firestore.firestore().collection("customers")
    static let storageRef = Storage.storage().reference().child("profile-pics")

    static func createInitialCustomerProfile(uid: String,
                                             signupDetails: SignupDetails,
                                             authDetails: AuthDetails,
                                             errorHandler: @escaping (Error) -> Void) {
        let db = Firestore.firestore()
        db.collection("customers")
            .document(uid)
            .setData(["uid": uid,
                      "name": signupDetails.name,
                      "contact": signupDetails.contact,
                      "email": authDetails.email]) { (error) in
                if let error = error {
                    errorHandler(error)
                }
            }
    }

    static func getCustomerInfo(completion: @escaping (Customer) -> Void,
                                errorHandler: @escaping (Error) -> Void) {
        guard let user = Auth.auth().currentUser else {
            errorHandler(ProfileError.NotSignedIn)
            return
        }
        let docRef = dbRef.document(user.uid)

        docRef.getDocument { (document, error) in
            if let error = error {
                errorHandler(error)
                return
            }
            if let data = document?.data() {
                if let customer = Customer(dictionary: data) {
                    completion(customer)
                    return
                } else {
                    errorHandler(ProfileError.CustomerObjectCreationError)
                }
            }
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
        guard let user = Auth.auth().currentUser else {
            errorHandler(ProfileError.UIImageNotFound)
            return
        }
        let docRef = dbRef.document(user.uid)

        docRef.updateData(customer.dictionary) { (error) in
            if let error = error {
                errorHandler(error)
                return
            }
            CustomerPostLoginSetupManager.customerDidUpdateProfile(updated: customer)
            completion()
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

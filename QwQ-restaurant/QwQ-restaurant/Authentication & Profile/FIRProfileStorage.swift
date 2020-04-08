//
//  FBProfileStorage.swift
//  QwQ-restaurant
//
//  Created by Daniel Wong on 18/3/20.
//

import FirebaseFirestore
import FirebaseStorage
import FirebaseUI
import SDWebImage

class FIRProfileStorage: ProfileStorage {
    typealias Auth = FIRAuthenticator

    static let dbRef = Firestore.firestore().collection(Constants.restaurantKey)
    static let storageRef = Storage.storage().reference().child("profile-pics")

    static func createInitialRestaurantProfile(uid: String,
                                               signupDetails: SignupDetails,
                                               authDetails: AuthDetails,
                                               errorHandler: @escaping (Error) -> Void) {
        let db = Firestore.firestore()
        db.collection(Constants.restaurantKey)
            .document(uid)
            .setData([Constants.uidKey: uid,
                      Constants.nameKey: signupDetails.name,
                      Constants.contactKey: signupDetails.contact,
                      Constants.emailKey: authDetails.email,
                      Constants.addressKey: "",
                      Constants.menuKey: ""]) { (error) in
            if let error = error {
                errorHandler(error)
            }
            }
    }

    static func getRestaurantInfo(completion: @escaping (Restaurant) -> Void,
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
                if let restaurant = Restaurant(dictionary: data) {
                    completion(restaurant)
                    return
                }
            }

            errorHandler(ProfileError.IncorrectUserType)
            Auth.logout(completion: {}, errorHandler: errorHandler)
        }
    }

    static func getRestaurantProfilePic(uid: String,
                                        placeholder imageView: UIImageView) {
        let reference = storageRef.child("\(uid).png")
        guard let image = imageView.image else {
            return
        }
        imageView.checkCacheThenSetImage(with: reference, placeholder: image)
    }

    static func updateRestaurantInfo(restaurant: Restaurant,
                                     completion: @escaping () -> Void,
                                     errorHandler: @escaping (Error) -> Void) {
        guard let uid = Auth.getUIDOfCurrentUser() else {
            errorHandler(ProfileError.NotSignedIn)
            return
        }
        let docRef = dbRef.document(uid)

        docRef.updateData(restaurant.dictionary) { (error) in
            if let error = error {
                errorHandler(error)
                return
            }
            completion()
        }
    }

    static func updateRestaurantProfilePic(uid: String,
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

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
import os.log

class FIRRestaurantStorage: RestaurantStorage {
    typealias Auth = FIRAuthenticator

    static var currentRestaurantUID: String?

    static let dbRef = Firestore.firestore().collection(Constants.restaurantsDirectory)
    static let storageRef = Storage.storage().reference().child(Constants.profilePicsDirectory)

    // MARK: - Restaurant Listener
    static weak var delegate: RestaurantStorageSyncDelegate?
    private static var restaurantListener: ListenerRegistration?

    static func createInitialRestaurantProfile(uid: String,
                                               signupDetails: SignupDetails,
                                               email: String,
                                               errorHandler: @escaping (Error) -> Void) {
        dbRef.document(uid)
            .setData([Constants.uidKey: uid,
                      Constants.nameKey: signupDetails.name,
                      Constants.contactKey: signupDetails.contact,
                      Constants.emailKey: email,
                      Constants.addressKey: "",
                      Constants.menuKey: "",
                      Constants.minGroupSizeKey: Restaurant.defaultMinGroupSize,
                      Constants.maxGroupSizeKey: Restaurant.defaultMaxGroupSize,
                      Constants.advanceBookingLimitKey: Restaurant.defaultAdvanceBookingLimit]) { (error) in
            if let error = error {
                errorHandler(error)
                os_log("Error creating restaurant",
                       log: Log.createRestaurantError,
                       type: .error,
                       error.localizedDescription)
            }
            }
    }

    static func getRestaurantInfo(completion: @escaping (Restaurant) -> Void,
                                  errorHandler: @escaping (Error) -> Void) {

        guard let uid = currentRestaurantUID else {
            errorHandler(ProfileError.NotSignedIn)
            return
        }

        let docRef = dbRef.document(uid)

        docRef.getDocument { (document, error) in
            if let error = error {
                errorHandler(error)
                os_log("Error getting restaurant documents",
                       log: Log.restaurantRetrievalError,
                       type: .error,
                       error.localizedDescription)
                return
            }
            
            if let data = document?.data() {
                if let restaurant = Restaurant(dictionary: data) {
                    completion(restaurant)
                    return
                }
            }

            errorHandler(ProfileError.InvalidRestaurant)
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
        guard let uid = currentRestaurantUID else {
            errorHandler(ProfileError.NotSignedIn)
            return
        }
        let docRef = dbRef.document(uid)

        docRef.setData(restaurant.dictionary) { (error) in
            if let error = error {
                errorHandler(error)
                os_log("Error updating restaurant",
                       log: Log.updateRestaurantError,
                       type: .error,
                       error.localizedDescription)
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

    // MARK: - Restaurant Listener
    
    static func registerListener(for restaurant: Restaurant) {
        removeListener()
        restaurantListener = dbRef.document(restaurant.uid)
            .addSnapshotListener(includeMetadataChanges: false) { (snapshot, err) in
                guard err == nil, let snapshot = snapshot else {
                     os_log("Error getting restaurant documents",
                            log: Log.restaurantRetrievalError,
                            type: .error,
                            String(describing: err))
                    return
                }
                guard let data = snapshot.data(),
                    let updatedRestaurant = Restaurant(dictionary: data) else {
                        assert(false, "document should be of correct format(fields) of a restaurant!")
                        return
                }

                delegate?.didUpdateRestaurant(restaurant: updatedRestaurant)
            }
    }

    static func removeListener() {
        restaurantListener?.remove()
        restaurantListener = nil
    }
}

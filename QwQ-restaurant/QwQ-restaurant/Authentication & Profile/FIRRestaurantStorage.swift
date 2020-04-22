//
//  FBProfileStorage.swift
//  QwQ-restaurant
//
//  Created by Daniel Wong on 18/3/20.
//

import FirebaseFirestore
import FirebaseFirestoreSwift
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
        do {
            try dbRef.document(uid)
                .setData(from:
                    Restaurant(uid: uid, name: signupDetails.name,
                               email: email, contact: signupDetails.contact,
                               address: "", menu: "",
                               maxGroupSize: Restaurant.defaultMaxGroupSize, minGroupSize: Restaurant.defaultMinGroupSize,
                               advanceBookingLimit: Restaurant.defaultAdvanceBookingLimit)
                    ) { (error) in
                if let error = error {
                    errorHandler(error)
                    os_log("Error creating restaurant",
                           log: Log.createRestaurantError,
                           type: .error,
                           error.localizedDescription)
                }
                }
        } catch {
            os_log("Error serializing restaurant.",
                   log: Log.createRestaurantError,
                   type: .error,
                   error.localizedDescription)
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
                os_log("Restaurant cannot be created.", log: Log.createRestaurantError, type: .error, error.localizedDescription)
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

        do {
            try docRef.setData(from: restaurant) { (error) in
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
        } catch {
            os_log("Error serializing restaurant.",
                   log: Log.updateRestaurantError, type: .error, error.localizedDescription)
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
                            type: .error, String(describing: err))
                    return
                }

                var updatedRestaurant: Restaurant
                let result = Result {
                    try snapshot.data(as: Restaurant.self)
                }
                switch result {
                case .success(let res):
                    if res == nil {
                        os_log("Restaurant document does not exist.", log: Log.createRestaurantError, type: .error)
                        assert(false, "document should be of correct format(fields) of a restaurant!")
                        return
                    }
                    updatedRestaurant = res!
                case .failure(let error):
                    os_log("Restaurant cannot be created.",
                           log: Log.createRestaurantError, type: .error, error.localizedDescription)
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

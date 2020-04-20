//
//  FIRPermissionStorage.swift
//  QwQ-restaurant
//
//  Created by Daniel Wong on 20/4/20.
//

import FirebaseFirestore

class FIRRoleStorage {
    typealias RestaurantStorage = FIRRestaurantStorage

    static let dbRef = Firestore.firestore().collection(Constants.restaurantsDirectory)

    static func getRestaurantRoles(completion: @escaping ([Role]) -> Void,
                                   errorHandler: @escaping (Error) -> Void) {
        guard let currentUID = RestaurantStorage.currentRestaurantUID else {
            errorHandler(ProfileError.NoRestaurantAssigned)
            return
        }

        let roleRef = dbRef.document(currentUID).collection(Constants.rolesDirectory)

        roleRef.getDocuments { (querySnapshot, error) in
            if let error = error {
                errorHandler(error)
                return
            }

            var roles = [Role]()

            for document in querySnapshot!.documents {
                if let role = Role(dictionary: document.data()) {
                    roles.append(role)
                }
            }

            completion(roles)
        }
    }

    static func setRestaurantRoles(roles: [Role],
                                   completion: @escaping () -> Void,
                                   errorHandler: @escaping (Error) -> Void) {

        guard let currentUID = RestaurantStorage.currentRestaurantUID else {
            errorHandler(ProfileError.NoRestaurantAssigned)
            return
        }

        let roleRef = dbRef.document(currentUID).collection(Constants.rolesDirectory)

        for role in roles {
            let docRef = roleRef.document(role.roleName)

            docRef.setData(role.dictionary)
        }

        completion()
    }

    static func deleteCurrentRoles(completion: @escaping () -> Void,
                                   errorHandler: @escaping (Error) -> Void) {
        guard let currentUID = RestaurantStorage.currentRestaurantUID else {
            errorHandler(ProfileError.NoRestaurantAssigned)
            return
        }

        let roleRef = dbRef.document(currentUID).collection(Constants.rolesDirectory)

        roleRef.getDocuments { (querySnapshot, error) in
            if let error = error {
                errorHandler(error)
                return
            }

            for document in querySnapshot!.documents {
                document.reference.delete()
            }
        }

        completion()

    }

}

//
//  FIRPermissionStorage.swift
//  QwQ-restaurant
//
//  Created by Daniel Wong on 20/4/20.
//

import FirebaseFirestore
import os

class FIRRoleStorage: RoleStorage {
    typealias RestaurantStorage = FIRRestaurantStorage

    static var defaultRole: String?

    static let dbRef = Firestore.firestore().collection(Constants.restaurantsDirectory)

    static func createDefaultRoles(uid: String, errorHandler: @escaping (Error) -> Void) {
        let roleRef = dbRef.document(uid).collection(Constants.rolesDirectory)

        for role in Role.defaultRoles {
            let docRef = roleRef.document(role.roleName)

            do {
                try docRef.setData(from: role) { (error) in
                    if let error = error {
                        errorHandler(error)
                    }
                }
            } catch {
                errorHandler(error)
            }
        }
    }

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
                let result = Result {
                    try document.data(as: Role.self)
                }
                switch result {
                case .success(let role):
                    if let role = role {
                        roles.append(role)
                    }
                case .failure(let error):
                    errorHandler(error)
                }
            }

            completion(roles)
        }
    }

    static func getRolePermissions(roleName: String,
                                   completion: @escaping([Permission]) -> Void,
                                   errorHandler: @escaping (Error) -> Void) {
        guard let currentUID = RestaurantStorage.currentRestaurantUID else {
            errorHandler(ProfileError.NoRestaurantAssigned)
            return
        }

        let permissionsRef = dbRef.document(currentUID).collection(Constants.rolesDirectory).document(roleName)

        permissionsRef.getDocument { (document, error) in
            if let error = error {
                errorHandler(error)
                return
            }

            let result = Result {
                try document?.data(as: Role.self)
            }
            switch result {
            case .success(let role):
                if let role = role {
                    completion(role.permissions)
                    return
                }
            case .failure:
                errorHandler(PermissionError.PermissionsNotInitialised)
            }
        }
    }

    static func setRestaurantRoles(roles: [Role],
                                   errorHandler: @escaping (Error) -> Void) {

        guard let currentUID = RestaurantStorage.currentRestaurantUID else {
            errorHandler(ProfileError.NoRestaurantAssigned)
            return
        }

        let roleRef = dbRef.document(currentUID).collection(Constants.rolesDirectory)

        do {
            for role in roles {
                let docRef = roleRef.document(role.roleName)

                try docRef.setData(from: role)
            }
        } catch {
            os_log("Error uploading roles",
                   log: Log.createRoleError,
                   type: .error,
                   error.localizedDescription)
        }

    }

    static func deleteRole(role: Role, completion: @escaping (Role) -> Void,
                           errorHandler: @escaping (Error) -> Void) {
        
        guard let currentUID = RestaurantStorage.currentRestaurantUID else {
            errorHandler(ProfileError.NoRestaurantAssigned)
            return
        }

        let staffRef = Firestore.firestore().collection(Constants.staffDirectory)

        staffRef.whereField(Constants.assignedRestaurantKey, isEqualTo: currentUID)
            .whereField(Constants.roleNameKey, isEqualTo: role.roleName).getDocuments { (querySnapshot, error) in
                if let error = error {
                    errorHandler(error)
                    return
                }

                if querySnapshot!.documents.isEmpty {
                    deleteDocumentForRole(role: role, errorHandler: errorHandler)
                    completion(role)
                } else {
                    errorHandler(PermissionError.PermissionInUse)
                }
            }
    }

    private static func deleteDocumentForRole(role: Role, errorHandler: @escaping (Error) -> Void) {
        guard let currentUID = RestaurantStorage.currentRestaurantUID else {
            errorHandler(ProfileError.NoRestaurantAssigned)
            return
        }
        let roleRef = dbRef.document(currentUID).collection(Constants.rolesDirectory)
        let docRef = roleRef.document(role.roleName)
        docRef.delete()
    }

}

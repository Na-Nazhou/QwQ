//
//  ProfileError.swift
//  QwQ-restaurant
//
//  Created by Daniel Wong on 20/3/20.
//

import Foundation

/// Contains the possible errors thrown by Profile
enum ProfileError: Error {
    case NotSignedIn
    case IncorrectUserType
    case InvalidRestaurant
    case UIImageNotFound
    case NoImageSelected
    case NoRestaurantAssigned
}

/// Descriptions for each ProfileError
extension ProfileError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .NotSignedIn:
            return "You are not signed in."
        case .IncorrectUserType:
            return "Please check that you are logging into the correct app."
        case .InvalidRestaurant:
            return "No such restaurant found. Perhaps it has closed?"
        case .UIImageNotFound:
            return "An error occured while trying to initialise the profile photo."
        case .NoImageSelected:
            return "No image was selected."
        case .NoRestaurantAssigned:
            return "You are not currently assigned to any restaurant!"
        }
    }
}

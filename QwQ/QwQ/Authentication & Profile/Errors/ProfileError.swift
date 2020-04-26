//
//  ProfileError.swift
//  QwQ
//
//  Created by Daniel Wong on 20/3/20.
//

import Foundation

/// Contains the possible errors thrown by Profile
enum ProfileError: Error {
    case NotSignedIn
    case UserProfileNotFound
    case UIImageNotFound
    case NoImageSelected
}

/// Descriptions for each ProfileError
extension ProfileError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .NotSignedIn:
            return "You are not signed in."
        case .UserProfileNotFound:
            return "Please check that you are logging into the correct app."
        case .UIImageNotFound:
            return "An error occured while trying to initialise the profile photo."
        case .NoImageSelected:
            return "No image was selected."
        }
    }
}

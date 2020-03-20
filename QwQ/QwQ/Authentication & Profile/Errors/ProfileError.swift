//
//  ProfileError.swift
//  QwQ
//
//  Created by Daniel Wong on 20/3/20.
//

import Foundation

enum ProfileError: Error {
    case NotSignedIn
    case CustomerObjectCreationError
    case UIImageNotFound
    case NoImageSelected
}

extension ProfileError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .NotSignedIn:
            return "You are not signed in."
        case .CustomerObjectCreationError:
            return "Please check that you are logging into the correct app."
        case .UIImageNotFound:
            return "An error occured while trying to initialise the profile photo."
        case .NoImageSelected:
            return "No image was selected."
        }
    }
}

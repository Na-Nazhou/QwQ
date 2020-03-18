//
//  Constants.swift
//  QwQ
//
//  Created by Tan Su Yee on 14/3/20.
//

import UIKit

struct Constants {
    // MARK: Tab bar settings
    static let barTintColor = UIColor(red: 255 / 255, green: 255 / 255, blue: 255 / 255, alpha: 1)
    static let tintColor = UIColor(red: 244 / 255, green: 107 / 255, blue: 116 / 255, alpha: 1)
    static let tabBarFont = UIFont(name: "Comfortaa-Regular", size: 15)
    
    // MARK: Profile settings
    static let profileBorderWidth = CGFloat(1)
    static let profileBorderColor = UIColor.white.cgColor
    
    // MARK: Alert settings
    static let missingFieldsTitle = "Error - Missing Fields"
    static let missingFieldsMessage = "Please fill in all the fields!"
    static let okayTitle = "Okay"
    static let cancelTitle = "Cancel"
    static let successfulUpdateTitle = "Success"
    static let successfulUpdateMessage = "Your profile has been updated."
    static let invalidEmailTitle = "Error - Invalid Email"
    static let invalidEmailMessage = "Please enter a valid email."
    static let invalidContactTitle = "Error - Invalid Contact"
    static let invalidContactMessage = "Please enter a valid contact number: 8 numbers only."
    static let missingEmailTitle = "Error - Missing Email"
    static let missingEmailMessage = "Please provide a valid email."
    static let missingPasswordTitle = "Error - Missing Password"
    static let missingPasswordMessage = "Please provide a valid password."
    static let chooseFromPhotoLibraryTitle = "Choose from Library"
    static let chooseFromCameraTitle = "Take from Camera"
    static let showImagePickerTitle = "Choose your image"
    
    // MARK: Segue settings
    static let signUpCompletedSegue = "signupCompleted"
    static let loginCompletedSegue = "loginCompleted"
    static let restaurantSelectedSegue = "restaurantSelected"
    static let queueSelectedSegue = "queueSelected"
    static let bookSelectedSegue = "bookSelected"
    
    // MARK: Collection view settings
    static let restaurantReuseIdentifier = "restaurantCell"
    static let restaurantSectionInsets = UIEdgeInsets(top: 20.0,
                                                    left: 30.0,
                                                    bottom: 20.0,
                                                    right: 30.0)
    static let activitiesReuseIdentifier = "activityCell"
    static let activitiesSectionInsets = UIEdgeInsets(top: 20.0,
                                                    left: 30.0,
                                                    bottom: 20.0,
                                                    right: 30.0)
}

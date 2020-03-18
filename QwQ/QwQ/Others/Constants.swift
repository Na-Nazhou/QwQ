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
    static let successTitle = "Success"
    static let errorTitle = "Error"
    static let okayTitle = "Okay"
    static let cancelTitle = "Cancel"

    // MARK: Signup / Profile
    static let profileUpdateSuccessMessage = "Your profile has been updated."
    static let missingFieldsTitle = "Error - Missing Fields"
    static let missingFieldsMessage = "Please fill in all the fields!"
    static let invalidEmailTitle = "Error - Invalid Email"
    static let invalidEmailMessage = "Please enter a valid email."
    static let invalidContactTitle = "Error - Invalid Contact"
    static let invalidContactMessage = "Please enter a valid contact number: 8 numbers only."
    static let missingEmailTitle = "Error - Missing Email"
    static let missingEmailMessage = "Please provide a valid email."
    static let missingPasswordTitle = "Error - Missing Password"
    static let missingPasswordMessage = "Please provide a valid password."

    // MARK: Profile photo
    static let chooseFromPhotoLibraryTitle = "Choose from Library"
    static let chooseFromCameraTitle = "Take from Camera"
    static let showImagePickerTitle = "Choose your image"

    // MARK: Queue record
    static let restaurantUnavailableMessage = "This restaurant is currently not open!"
    static let multipleQueueRecordsMessage = "You have an existing queue record."
    static let queueRecordCreateSuccessMessage = "You have created a new queue record."
    static let queueRecordUpdateSuccessMessage = "Your queue record has been updated."
    static let queueRecordDeleteSuccessMessage = "Your queue record has been deleted."

    // MARK: Book record
    static let bookRecordCreateSuccessMessage = "You have created a book record."
    static let bookRecordUpdateSuccessMessage = "This book record has been updated."
    static let bookRecordDeleteSuccessMessage = "This book record has been deleted."
    
    // MARK: Segue settings
    static let signUpCompletedSegue = "signupCompleted"
    static let loginCompletedSegue = "loginCompleted"
    static let restaurantSelectedSegue = "restaurantSelected"
    static let queueSelectedSegue = "queueSelected"
    static let bookSelectedSegue = "bookSelected"
    static let editQueueSelectedSegue = "editQueueSelected"
    static let editBookSelectedSegue = "editBookSelected"
    static let logoutSegue = "logout"
    
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
    static let collectionViewHeaderReuseIdentifier = "collectionViewHeader"
}

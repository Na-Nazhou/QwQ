//
//  Constants.swift
//  QwQ-restaurant
//
//  Created by Tan Su Yee on 14/3/20.
//  Copyright © 2020 Appfish. All rights reserved.
//

import UIKit

struct Constants {
    
    // MARK: Tab bar settings
    static let barTintColor = UIColor(red: 255 / 255, green: 255 / 255, blue: 255 / 255, alpha: 1)
    static let tintColor = UIColor(red: 244 / 255, green: 107 / 255, blue: 116 / 255, alpha: 1)
    static let tabBarFont = UIFont(name: "Comfortaa-Regular", size: 30)
    static let tabBarHeight = CGFloat(100)
    
    // MARK: Profile settings
    static let profileBorderWidth = CGFloat(1)
    static let profileBorderColor = UIColor.white.cgColor
    
    // MARK: Alert settings
    static let missingFieldsTitle = "Error - Missing Fields"
    static let missingFieldsMessage = "Please fill in all the fields!"
    static let errorTitle = "Error"
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
    static let admitCustomerTitle = "Admit Customer"
    static let admitCustomerMessage = "The customer has been notified."
    static let removeCustomerTitle = "Remove Customer"
    static let removeCustomerMessage = "The customer has been removed from queue."
    
    // MARK: Segue settings
    static let signUpCompletedSegue = "signupCompleted"
    static let loginCompletedSegue = "loginCompleted"
    static let queueRecordSelectedSegue = "queueRecordSelected"
    static let bookRecordSelectedSegue = "bookRecordSelected"
    static let logoutSegue = "logout"

    // MARK: Storage settings
    static let customersDirectory = "customers"
    static let restaurantsDirectory = "restaurants"
    static let queuesDirectory = "queues"
    
    // MARK: Collection view settings
    static let queueRecordReuseIdentifier = "queueRecordCell"
    static let queueRecordSectionInsets = UIEdgeInsets(top: 20.0,
                                                       left: 30.0,
                                                       bottom: 20.0,
                                                       right: 30.0)
    static let collectionViewHeaderReuseIdentifier = "collectionViewHeader"
    
    // MARK: Segmented control settings
    static let segmentedControlTitles = ["Active", "History"]
    static let segmentedControlDefaultSelectedIndex = 0
    static let segmentedControlSelectedLabelColor = UIColor.black
    static let segmentedControlUnselectedLabelColor = UIColor.white
    static let segmentedControlThumbColor = UIColor.white
    static let segmentedControlBorderColor = UIColor.white
    static let segmentedControlFont = UIFont(name: "Comfortaa-Regular", size: 24)
    static let segmentedControlLayerBorderColor = UIColor(white: 1.0, alpha: 0.5).cgColor
    static let segmentedControlLayerBorderWidth = CGFloat(2)
    static let segmentedControlLabelFrame = CGRect(x: 0, y: 0, width: 70, height: 40)
    static let segmentedControlLabelFont = UIFont(name: "Comfortaa-Regular", size: 30)
    static let segmentedControlAnimationDuration = 0.5
    static let segmentedControlAnimationDelay = 0.0
}

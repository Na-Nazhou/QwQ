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
    static let tabBarFont = UIFont(name: "Comfortaa-Regular", size: 20)
    static let tabBarHeight = CGFloat(60)
    
    // MARK: Profile settings
    static let profileBorderWidth = CGFloat(1)
    static let profileBorderColor = UIColor.white.cgColor
    static let chooseFromPhotoLibraryTitle = "Choose from Library"
    static let chooseFromCameraTitle = "Take from Camera"
    static let showImagePickerTitle = "Choose your image"
    static let welcomeMessage = "Welcome to QwQ!"
    static let profileSetupMessage = "Please set up your profile in the Profile tab."
    + "Until then, your restaurant will not be visible to customers."
    static let openAfterCloseMessage = "Open time must be before close time"
    static let duplicateEmailTitle = "Error - Duplicate Email"
    static let duplicateEmailMessage = "This email already exists."

    // MARK: Alert settings
    static let successTitle = "Success"
    static let errorTitle = "Error"
    static let okayTitle = "Okay"
    static let cancelTitle = "Cancel"
    
    // MARK: Signup / Login settings
    static let missingFieldsTitle = "Error - Missing Fields"
    static let missingFieldsMessage = "Please fill in all the fields!"
    static let profileUpdateSuccessMessage = "Your profile has been updated."
    static let invalidEmailTitle = "Error - Invalid Email"
    static let invalidEmailMessage = "Please enter a valid email."
    static let invalidContactTitle = "Error - Invalid Contact"
    static let invalidContactMessage = "Please enter a valid contact number: 8 numbers only."
    static let missingEmailTitle = "Error - Missing Email"
    static let missingEmailMessage = "Please provide a valid email."
    static let missingPasswordTitle = "Error - Missing Password"
    static let missingPasswordMessage = "Please provide a valid password."
    static let resetPasswordTitle = "Reset Password"
    static let resetPasswordMessage = "Please check your email to reset your password."

    // MARK: Record settings
    static let admitCustomerTitle = "Admit Customer"
    static let admitCustomerMessage = "The customer has been notified."
    static let serveCustomerTitle = "Serve Customer"
    static let serveCustomerMessage = "The customer has been served."
    static let rejectCustomerTitle = "Reject Customer"
    static let rejectCustomerMessage = "The customer has been rejected."
    static let recordDateFormat = "ddMMyyyy"
    
    // MARK: Segue settings
    static let signUpCompletedSegue = "signupCompleted"
    static let loginCompletedSegue = "loginCompleted"
    static let emailNotVerifiedSegue = "emailNotVerified"
    static let queueRecordSelectedSegue = "queueRecordSelected"
    static let bookRecordSelectedSegue = "bookRecordSelected"
    static let statisticsSelectedSegue = "statisticsSelected"
    static let logoutSegue = "logout"
    static let staffNotVerifiedSegue = "staffNotVerified"
    static let noAssignedRestaurantSegue = "noAssignedRestaurant"

    // MARK: Storage settings
    static let customersDirectory = "customers"
    static let restaurantsDirectory = "restaurants"
    static let queuesDirectory = "queues"
    static let bookingsDirectory = "bookings"
    static let staffDirectory = "staff"
    static let profilePicsDirectory = "profile-pics"
    static let rolesDirectory = "roles"
    
    // MARK: Collection view settings
    static let queueRecordReuseIdentifier = "queueRecordCell"
    static let collectionViewHeaderReuseIdentifier = "collectionViewHeader"
    static let activityCellHeight = CGFloat(300)
    static let statisticsReuseIdentifier = "statisticsCell"
    static let staffReuseIdentifier = "staffCell"
    
    // MARK: Segmented control settings
    static let segmentedControlActivitiesTitles = ["Current", "Waiting", "History"]
    static let segmentedControlStatisticsTitles = ["Daily", "Weekly", "Monthly"]
    static let segmentedControlSignUpTitles = ["Staff", "Restaurant"]
    static let segmentedControlDefaultSelectedIndex = 0
    static let segmentedControlSelectedLabelColor = UIColor.black
    static let segmentedControlUnselectedLabelColor = UIColor.white
    static let segmentedControlThumbColor = UIColor.white
    static let segmentedControlBorderColor = UIColor.white
    static let segmentedControlFont = UIFont(name: "Comfortaa-Regular", size: 24)
    static let segmentedControlLayerBorderColor = UIColor(white: 1.0, alpha: 0.5).cgColor
    static let segmentedControlLayerBorderWidth = CGFloat(2)
    static let segmentedControlLabelFrame = CGRect(x: 0, y: 0, width: 70, height: 40)
    static let segmentedControlLabelFont = UIFont(name: "Comfortaa-Regular", size: 20)
    static let segmentedControlAnimationDuration = 0.5
    static let segmentedControlAnimationDelay = 0.0
    
    // MARK: Spinner settings
    static let spinnerViewBackgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
    static let spinnerViewFrame = CGRect(x: 0.0, y: 0.0, width: 80.0, height: 80.0)
    static let spinnerViewColor = UIColor.white
    
    // MARK: Restaurant queue activities settings
    static let buttonTextToOpenQueue = "CLICK TO OPEN"
    static let buttonTextToCloseQueue = "CLICK TO CLOSE"
    
    // MARK: Statistics settings
    static let startAfterEndMessage = "Start date must be before end date"
    
    // MARK: Model settings
    static let uidKey = "uid"
    static let nameKey = "name"
    static let emailKey = "email"
    static let contactKey = "contact"
    static let addressKey = "address"
    static let menuKey = "menu"
    static let queueOpenTimeKey = "queueOpenTime"
    static let queueCloseTimeKey = "queueCloseTime"
    static let maxGroupSizeKey = "maxGroupSize"
    static let minGroupSizeKey = "minGroupSize"
    static let advanceBookingLimitKey = "advanceBookingLimit"
    static let autoOpenTimeKey = "autoOpenTime"
    static let autoCloseTimeKey = "autoCloseTime"
    static let customerKey = "customer"
    static let restaurantKey = "restaurant"
    static let groupSizeKey = "groupSize"
    static let babyChairQuantityKey = "babyChairQuantity"
    static let wheelChairFriendlyKey = "wheelChairFriendly"
    static let admitTimeKey = "admitTime"
    static let estimatedAdmitTimeKey = "estimatedAdmitTime"
    static let serveTimeKey = "serveTime"
    static let rejectTimeKey = "rejectTime"
    static let withdrawTimeKey = "withdrawTime"
    static let confirmAdmissionTimeKey = "confirmAdmissionTime"
    static let missTimeKey = "missTime"
    static let readmitTimeKey = "readmitTime"
    static let startTimeKey = "startTime"
    static let timeKey = "time"
    static let assignedRestaurantKey = "assignedRestaurant"
    static let isOwnerKey = "isOwner"
    static let permissionsKey = "permissions"
    static let roleNameKey = "roleName"

    // MARK: Queue timed settings
    static let inactivateAdmitAfterMissTimeInMins = 10.0
    static let timeBufferForBookArrivalInMins = 15.0
    static let queueWaitConfirmTimeInMins = 3.0
    static let queueWaitArrivalInMins = 15.0
}

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
    static let chooseFromPhotoLibraryTitle = "Choose from Library"
    static let chooseFromCameraTitle = "Take from Camera"
    static let showImagePickerTitle = "Choose your image"
    
    // MARK: Alert settings
    static let successTitle = "Success"
    static let errorTitle = "Error"
    static let okayTitle = "Okay"
    static let cancelTitle = "Cancel"

    // MARK: Signup / Login / Profile
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
    static let loginCancelledMessage = "The login process with Facebook was cancelled."
    static let fbLoginPermissionsMessage = "Please grant profile and email access with Facebook to continue."
    static let resetPasswordTitle = "Reset Password"
    static let resetPasswordMessage = "Please check your email to reset your password."

    // MARK: Queue record settings
    static let restaurantUnavailableMessage = "This restaurant queue is currently not open!"
    static let multipleQueueRecordsMessage = "You have an existing queue record."
    static let recordDeleteSuccessMessage = "Your record has been deleted."
    static let recordCreateSuccessMessage = "You have created a record."
    static let recordUpdateSuccessMessage = "Your record has been updated."
    
    // MARK: Record settings
    static let defaultWheelchairFriendly = false
    static let defaultBabyChairQuantity = 0
    
    // MARK: Segue settings
    static let signUpCompletedSegue = "signupCompleted"
    static let loginCompletedSegue = "loginCompleted"
    static let emailNotVerifiedSegue = "emailNotVerified"
    static let restaurantSelectedSegue = "restaurantSelected"
    static let queueSelectedSegue = "queueSelected"
    static let bookSelectedSegue = "bookSelected"
    static let editQueueSelectedSegue = "editQueueSelected"
    static let editBookSelectedSegue = "editBookSelected"
    static let logoutSegue = "logout"
    static let fbLoginCompletedSegue = "fbLoginComplete"
    static let loginEmailNotVerifiedSegue = "loginEmailNotVerified"

    // MARK: Storage settings
    static let customersDirectory = "customers"
    static let restaurantsDirectory = "restaurants"
    static let queuesDirectory = "queues"
    static let bookingsDirectory = "bookings"
    
    // MARK: Collection view settings
    static let restaurantReuseIdentifier = "restaurantCell"
    static let activitiesReuseIdentifier = "activityCell"
    static let collectionViewHeaderReuseIdentifier = "collectionViewHeader"
    static let restaurantCellHeight = CGFloat(270)
    static let selectedRestaurantColor = UIColor(red: 239 / 255, green: 240 / 255, blue: 241 / 255, alpha: 1)
    static let deselectRestaurantColor = UIColor.clear
    
    // MARK: Popover content settings
    static let popoverContentControllerIdentifier = "PopoverContentController"
    static let popoverContentControllerOffset = CGFloat(20)
    static let popoverContentReuseIdentifier = "popoverContentCell"
    static let sortCriteria = ["Name", "Location"]
    
    // MARK: Segmented control settings
    static let segmentedControlTitles = ["Active", "History"]
    static let segmentedControlDefaultSelectedIndex = 0
    static let segmentedControlSelectedLabelColor = UIColor.black
    static let segmentedControlUnselectedLabelColor = UIColor.white
    static let segmentedControlThumbColor = UIColor.white
    static let segmentedControlBorderColor = UIColor.white
    static let segmentedControlFont = UIFont(name: "Comfortaa-Regular", size: 12)
    static let segmentedControlLayerBorderColor = UIColor(white: 1.0, alpha: 0.5).cgColor
    static let segmentedControlLayerBorderWidth = CGFloat(2)
    static let segmentedControlLabelFrame = CGRect(x: 0, y: 0, width: 70, height: 40)
    static let segmentedControlLabelFont = UIFont(name: "Comfortaa-Regular", size: 15)
    static let segmentedControlAnimationDuration = 0.5
    static let segmentedControlAnimationDelay = 0.0
    
    // MARK: Spinner settings
    static let spinnerViewBackgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
    static let spinnerViewFrame = CGRect(x: 0.0, y: 0.0, width: 80.0, height: 80.0)
    static let spinnerViewColor = UIColor.white
    
    // MARK: Record settings
    static let recordDateFormat = "ddMMyyyy"
    
    // MARK: Button settings
    static let selectOneText = "SELECT ONE"
    static let selectAllText = "SELECT ALL"
    static let queueButtonTitle = "QUEUE"
    static let bookButtonTitle = "BOOK"
    
    // MARK: Model settings
    static let uidKey = "uid"
    static let nameKey = "name"
    static let emailKey = "email"
    static let contactKey = "contact"
    static let addressKey = "address"
    static let menuKey = "menu"
    static let isRestaurantOpenKey = "isRestaurantOpen"
    static let queueOpenTimeKey = "queueOpenTime"
    static let queueCloseTimeKey = "queueCloseTime"
    static let customerKey = "customer"
    static let restaurantKey = "restaurant"
    static let groupSizeKey = "groupSize"
    static let babyChairQuantityKey = "babyChairQuantity"
    static let wheelChairFriendlyKey = "wheelChairFriendly"
    static let startTimeKey = "startTime"
    static let admitTimeKey = "admitTime"
    static let serveTimeKey = "serveTime"
    static let rejectTimeKey = "rejectTime"
    static let withdrawTimeKey = "withdrawTime"
    static let timeKey = "time"
}

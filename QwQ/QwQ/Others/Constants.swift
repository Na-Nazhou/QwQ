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
    static let restaurantUnavailableMessage = "The queue for %@ is closed!"
    static let alreadyQueuedRestaurantMessage = "You are already in the queue for %@."
    static let queueButtonTitle = "QUEUE"
    static let canQueueButtonAlpha = CGFloat(1)
    static let cannotQueueButtonAlpha = CGFloat(0.5)
    
    // MARK: Book record settings
    static let alreadyBookRestaurantMessage = "You have a booking at %@ already."
    static let exceedAdvanceBookingLimitMessage = "You have to book at least %@ hours in advance at %@."
    static let exceedOperatingHoursMessage = "%@ only operates at %@"
    static let bookingTimeInterval = 15
    static let bookButtonTitle = "BOOK"
    
    // MARK: Record settings
    static let defaultWheelchairFriendly = false
    static let defaultBabyChairQuantity = 0
    
    static let noRestaurantSelectedMessage = "You have to select at least one restaurant"
    static let recordCreateSuccessMessage = "You have created a record."
    static let multipleRecordCreateSuccessMessage = "You have successfully created multiple records."
    static let recordUpdateSuccessMessage = "Your record has been updated."
    static let recordConfirmSuccessMessage = "Your record has been confirmed."
    static let recordWithdrawSuccessMessage = "Your record has been withdrawn."
    static let recordDateFormat = "ddMMyyyy"
    static let selectOneText = "SELECT ONE"
    static let selectAllText = "SELECT ALL"
    static let missingRecordFieldsTitle = "Missing fields"
    static let groupSizeErrorMessage = "Group size must be positive"
    static let groupSizeBabyChairErrorMessage = "Group size must be greater than baby chair quantity!"
    static let groupSizeMinSizeMessage = "Group size must be larger than the minimum group size"
    static let groupSizeMaxSizeMessage = "Group size must be smaller than the maximum group size"
    
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
    static let emailVerificationCancelledSegue = "goToLogin"
    
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
    static let deselectedRestaurantColor = UIColor.clear
    
    // MARK: Popover content settings
    static let popoverContentControllerIdentifier = "PopoverContentController"
    static let popoverContentControllerOffset = CGFloat(20)
    static let popoverContentReuseIdentifier = "popoverContentCell"
    static let sortCriteria = ["Name", "Location"]
    static let maxTableHeight = CGFloat(400)
    static let popoverWidth = CGFloat(80.0)
    static let popoverHeight = CGFloat(80.0)
    
    // MARK: Segmented control settings
    static let segmentedControlTitles = ["Active", "Missed", "History"]
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
    
    // MARK: Queue timed settings
    static let queueWaitConfirmTimeInMins = 3
    static let queueWaitArrivalInMins = 15
    
    // MARK: Notification settings
    static let permissionsRequestTitle = "Notifications Required!"
    static let permissionsRequestMessage = "Notifications are necessary to respond to your queues/bookings promptly!"
        + " Please head over to Settings and enable notifications for QwQ."
    static let permissionsRequestSettingsTitle = "Settings"
    static let acceptKeyword = "Accepted"
    static let acceptDescription = "You can now view your accepted booking in the "
        + "Activities page! Please arrive on time."
    static let rejectKeyword = "Rejected"
    static let rejectDescription = "You may consider booking at other restaurants."
    static let bookTimeTitle = "Time to Enter for Your Booking!"
    static let admitQueueDescription = "Accept or reject the admission on the Activities page! \nRespond within: 3 min"
    static let withdrawableAdmitOneMinDescription = "Accept or reject the admission on the "
        + "Activities page! \nRespond within: 2 min"
    static let withdrawableAdmitTwoMinDescription = "Accept or reject the admission on the "
        + "Activities page! \nRespond within: 1 min"
    static let confirmedAdmissionDescription = "Please arrive within 15min from the admitted time."
    static let queueRejectedDescription = "Please try to be prompt next time."
    static let queueMissedDescription = "You have been pushed back in the queue. Please wait in the vicinity."
}

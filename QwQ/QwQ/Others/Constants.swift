//
//  Constants.swift
//  QwQ
//
//  Created by Tan Su Yee on 14/3/20.
//

import UIKit

struct Constants {
    // MARK: Profile settings
    static let profileBorderWidth = CGFloat(1)
    static let profileBorderColor = UIColor.white.cgColor
    
    // MARK: Alert settings
    static let missingFieldsTitle = "Error - Missing Fields"
    static let missingFieldsMessage = "Please fill in all the fields!"
    static let okayButton = "Okay"
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
    
    // MARK: Segue settings
    static let signUpCompletedSegue = "signupCompleted"
    static let loginCompletedSegue = "loginCompleted"
}

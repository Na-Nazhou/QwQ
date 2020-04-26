//
//  SignUpViewController.swift
//  QwQ-restaurant
//
//  Created by Tan Su Yee on 14/3/20.
//

/**
`SignUpViewController` manages sign ups of staffs or restaurants.
 
 It must conform to `SignupLogicDelegate` so that user can be signed up and stored in the database.
*/

import UIKit

class SignUpViewController: UIViewController {

    // MARK: View properties
    @IBOutlet private var nameTextField: UITextField!
    @IBOutlet private var contactTextField: UITextField!
    @IBOutlet private var emailTextField: UITextField!
    @IBOutlet private var passwordTextField: UITextField!
    @IBOutlet private var segmentedControl: SegmentedControl!
    
    private var spinner: UIView?
    
    typealias Auth = FIRAuthenticator
    typealias RestaurantProfile = FIRRestaurantStorage
    typealias StaffProfile = FIRStaffStorage
    typealias RoleStorage = FIRRoleStorage

    private var selectedUserType: UserType = .staff

    private var trimmedName: String? {
        nameTextField.text?.trimmingCharacters(in: .newlines)
    }

    private var trimmedContact: String? {
        contactTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var trimmedEmail: String? {
        emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var trimmedPassword: String? {
        passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.registerObserversForKeyboard()
        self.hideKeyboardWhenTappedAround()
        
        setUpSegmentedControl()
    }

    @IBAction private func handleBack(_ sender: Any) {
        handleBack()
    }
    
    /// Sign up user if user details are valid
    @IBAction private func handleSubmit(_ sender: Any) {
        // Check and validate all fields
        guard checkIfAllFieldsAreFilled() else {
            showMessage(title: Constants.missingFieldsTitle,
                        message: Constants.missingFieldsMessage,
                        buttonText: Constants.okayTitle,
                        buttonAction: nil)
            return
        }
        
        guard let name = trimmedName, let contact = trimmedContact,
            let email = trimmedEmail, let password = trimmedPassword else {
                return
        }
        
        guard ValidationUtilities.validateEmail(email: email) else {
            showMessage(title: Constants.invalidEmailTitle,
                        message: Constants.invalidEmailMessage,
                        buttonText: Constants.okayTitle,
                        buttonAction: nil)
            return
        }
        
        guard ValidationUtilities.validateContact(contact: contact) else {
            showMessage(title: Constants.invalidContactTitle,
                        message: Constants.invalidContactMessage,
                        buttonText: Constants.okayTitle,
                        buttonAction: nil)
            return
        }

        spinner = showSpinner(onView: view)

        // Sign up user and log user in
        let signupDetails = SignupDetails(name: name, contact: contact)
        let authDetails = AuthDetails(email: email, password: password)

        beginLogin(signupDetails: signupDetails, authDetails: authDetails, selectedUserType: selectedUserType)
    }

    @IBAction private func onTapSegButton(_ sender: SegmentedControl) {
        selectedUserType = UserType(rawValue: sender.selectedIndex)!
    }
    
    private func setUpSegmentedControl() {
        segmentedControl.items = Constants.segmentedControlSignUpTitles
    }

    private func beginLogin(signupDetails: SignupDetails, authDetails: AuthDetails, selectedUserType: UserType) {
        let signupLogic = FIRSignupLogic(authDetails: authDetails,
                                         signupDetails: signupDetails,
                                         userType: selectedUserType)
        signupLogic.delegate = self
        signupLogic.beginSignup()
    }

    private func getStaffInfoComplete(staff: Staff) {
        if let assignedRestaurant = staff.assignedRestaurant {
            RestaurantProfile.currentRestaurantUID = assignedRestaurant
            RestaurantProfile.getRestaurantInfo(completion: getRestaurantInfoComplete(restaurant:),
                                                errorHandler: handleError(error:))
        } else {
            performSegue(withIdentifier: Constants.staffNotVerifiedSegue, sender: self)
        }
    }

    private func getRestaurantInfoComplete(restaurant: Restaurant) {
        RoleStorage.defaultRole = restaurant.defaultRole
        RestaurantPostLoginSetupManager.setUp(asIdentity: restaurant)
        removeSpinner(spinner)
        performSegue(withIdentifier: Constants.signUpCompletedSegue, sender: self)
    }
    
    private func checkIfAllFieldsAreFilled() -> Bool {
        if let name = nameTextField.text,
            let contact = contactTextField.text,
            let email = emailTextField.text,
            let password = passwordTextField.text {
            return !name.trimmingCharacters(in: .newlines).isEmpty &&
                !contact.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
                !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
                !password.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        }
        return false
    }
}

extension SignUpViewController: SignupLogicDelegate {
    /// Set up profile and staff info after sign up is completed
    func signUpComplete() {
        /* Email verification code - to be enabled only in production application
        performSegue(withIdentifier: Constants.emailNotVerifiedSegue, sender: self)
        return
        */

        if selectedUserType == UserType.staff {
            StaffProfile.getStaffInfo(completion: getStaffInfoComplete(staff:), errorHandler: handleError(error:))
        } else {
            RestaurantProfile.getRestaurantInfo(completion: getRestaurantInfoComplete(restaurant:),
                                                errorHandler: handleError(error:))
        }
    }
    
    /// Show error message and remove loading spinner
    func handleError(error: Error) {
        showMessage(title: Constants.errorTitle, message: error.localizedDescription, buttonText: Constants.okayTitle)
        removeSpinner(spinner)
    }
}

//
//  SignUpViewController.swift
//  QwQ-restaurant
//
//  Created by Tan Su Yee on 14/3/20.
//

import UIKit

class SignUpViewController: UIViewController, SignupLogicDelegate {

    // MARK: View properties
    @IBOutlet private var nameTextField: UITextField!
    @IBOutlet private var contactTextField: UITextField!
    @IBOutlet private var emailTextField: UITextField!
    @IBOutlet private var passwordTextField: UITextField!
    @IBOutlet private var segmentedControl: SegmentedControl!
    
    var spinner: UIView?
    
    typealias Auth = FIRAuthenticator
    typealias RestaurantProfile = FIRRestaurantStorage

    var selectedUserType: UserType = .staff

    override func viewDidLoad() {
        super.viewDidLoad()

        self.registerObserversForKeyboard()
        self.hideKeyboardWhenTappedAround()
        
        setUpSegmentedControl()
    }

    @IBAction private func handleBack(_ sender: Any) {
        handleBack()
    }
    
    @IBAction private func submitButton(_ sender: Any) {
        let trimmedName = nameTextField.text?.trimmingCharacters(in: .newlines)
        let trimmedContact = contactTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedEmail = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedPassword = passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        
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
    
    func signUpComplete() {
        RestaurantProfile.getRestaurantInfo(completion: getRestaurantInfoComplete(restaurant:),
                                            errorHandler: handleError(error:))
    }

    private func getRestaurantInfoComplete(restaurant: Restaurant) {
        RestaurantPostLoginSetupManager.setUp(asIdentity: restaurant)
        removeSpinner(spinner)
        performSegue(withIdentifier: Constants.signUpCompletedSegue, sender: self)
    }

    func handleError(error: Error) {
        showMessage(title: Constants.errorTitle, message: error.localizedDescription, buttonText: Constants.okayTitle)
        removeSpinner(spinner)
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

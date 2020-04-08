//
//  EditProfileViewController.swift
//  QwQ
//
//  Created by Daniel Wong on 14/3/20.
//

import UIKit

class EditProfileViewController: UIViewController {

    @IBOutlet private var nameTextField: UITextField!
    @IBOutlet private var emailTextField: UITextField!
    @IBOutlet private var newPasswordTextField: UITextField!
    @IBOutlet private var contactTextField: UITextField!
    @IBOutlet private var addressTextField: UITextField!
    @IBOutlet private var menuTextView: UITextView!
    @IBOutlet private var minGroupSizeTextField: UITextField!
    @IBOutlet private var autoOpenTimeTextField: UITextField!
    @IBOutlet private var maxGroupSizeTextField: UITextField!
    @IBOutlet private var autoCloseTimeTextField: UITextField!
    @IBOutlet private var advanceBookingLimitTextField: UITextField!
    
    @IBOutlet private var profileImageView: UIImageView!

    typealias Auth = FIRAuthenticator
    typealias Profile = FIRProfileStorage

    private var uid: String?
    private var queueOpenTime: Date?
    private var queueCloseTime: Date?

    private var image: UIImage?

    private var spinner: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.registerObserversForKeyboard()
        self.hideKeyboardWhenTappedAround()
    }

    override func viewWillAppear(_ animated: Bool) {
        spinner = showSpinner(onView: view)
        Profile.getRestaurantInfo(completion: getRestaurantInfoComplete(restaurant:),
                                  errorHandler: handleError(error:))
        super.viewWillAppear(animated)
    }

    @IBAction private func handleBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    @IBAction private func saveButton(_ sender: Any) {
        let trimmedName = nameTextField.text?.trimmingCharacters(in: .newlines)
        let trimmedEmail = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedContact = contactTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedAddress = addressTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedMenu = menuTextView.text

        guard checkIfAllFieldsAreFilled() else {
            showMessage(title: Constants.missingFieldsTitle,
                        message: Constants.missingFieldsMessage,
                        buttonText: Constants.okayTitle,
                        buttonAction: nil)
            return
        }
        
        guard let uid = uid, let name = trimmedName, let email = trimmedEmail, let contact = trimmedContact,
            let address = trimmedAddress, let menu = trimmedMenu else {
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

        if let image = image {
            Profile.updateRestaurantProfilePic(uid: uid, image: image, errorHandler: handleError(error:))
        }

        if let password = newPasswordTextField.text {
            changePassword(password)
        }

        let restaurant = Restaurant(uid: uid, name: name, email: email, contact: contact,
                                    address: address, menu: menu,
                                    queueOpenTime: queueOpenTime, queueCloseTime: queueCloseTime)

        Profile.updateRestaurantInfo(restaurant: restaurant,
                                     completion: updateComplete,
                                     errorHandler: handleError(error:))
    }

    @objc func handleProfileTap(_ sender: UITapGestureRecognizer) {
        showImagePickerControllerActionSheet()
    }

    private func getRestaurantInfoComplete(restaurant: Restaurant) {
        self.uid = restaurant.uid
        self.nameTextField.text = restaurant.name
        self.emailTextField.text = restaurant.email
        self.contactTextField.text = restaurant.contact
        self.addressTextField.text = restaurant.address
        self.menuTextView.text = restaurant.menu
        self.queueOpenTime = restaurant.queueOpenTime
        self.queueCloseTime = restaurant.queueCloseTime

        setUpProfileImageView(uid: restaurant.uid)

        removeSpinner(spinner)
    }

    private func changePassword(_ password: String) {
        let trimmedPassword = password.trimmingCharacters(in: .newlines)
        guard !trimmedPassword.isEmpty else {
            return
        }
        Auth.changePassword(password, errorHandler: handleError(error:))
    }

    private func updateComplete() {
        removeSpinner(spinner)
        showMessage(title: Constants.successTitle,
                    message: Constants.profileUpdateSuccessMessage,
                    buttonText: Constants.okayTitle,
                    buttonAction: { _ in self.navigationController?.popViewController(animated: true) })
    }

    private func setUpProfileImageView(uid: String) {
        let profileTapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                                 action: #selector(self.handleProfileTap(_:)))
        profileImageView.addGestureRecognizer(profileTapGestureRecognizer)
        profileImageView.isUserInteractionEnabled = true

        Profile.getRestaurantProfilePic(uid: uid, placeholder: profileImageView)
    }

    private func handleError(error: Error) {
        showMessage(title: Constants.errorTitle, message: error.localizedDescription, buttonText: Constants.okayTitle)
        removeSpinner(spinner)
    }

    private func checkIfAllFieldsAreFilled() -> Bool {
        if let name = nameTextField.text,
            let email = emailTextField.text,
            let contact = contactTextField.text,
            let address = addressTextField.text,
            let menu = menuTextView.text {
            return !name.trimmingCharacters(in: .newlines).isEmpty &&
                !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
                !contact.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
                !address.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
                !menu.isEmpty
        }
        return false
    }

}

extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func showImagePickerControllerActionSheet() {
        let photoLibraryAction = UIAlertAction(
        title: Constants.chooseFromPhotoLibraryTitle, style: .default
        ) { _ in
            self.showImagePickerController(sourceType: .photoLibrary)
        }
        let cameraAction = UIAlertAction(
        title: Constants.chooseFromCameraTitle, style: .default
        ) { _ in
            self.showImagePickerController(sourceType: .camera)
        }
        let cancelAction = UIAlertAction(title: Constants.cancelTitle, style: .cancel, handler: nil)
        
        AlertService.showAlert(style: .actionSheet,
                               title: Constants.showImagePickerTitle,
                               message: nil,
                               actions: [photoLibraryAction, cameraAction, cancelAction])
    }
    
    func showImagePickerController(sourceType: UIImagePickerController.SourceType) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = sourceType
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            profileImageView.image = editedImage
            image = editedImage
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profileImageView.image = originalImage
            image = originalImage
        }
        dismiss(animated: true, completion: nil)
        
    }
    
}

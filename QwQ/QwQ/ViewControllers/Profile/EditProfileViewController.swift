//
//  EditProfileViewController.swift
//  QwQ
//
//  Created by Daniel Wong on 14/3/20.
//

import UIKit

class EditProfileViewController: UIViewController {

    // MARK: View properties
    @IBOutlet private var nameTextField: UITextField!
    @IBOutlet private var contactTextField: UITextField!
    @IBOutlet private var emailTextField: UITextField!
    @IBOutlet private var newPasswordTextField: UITextField!
    @IBOutlet private var profileImageView: UIImageView!

    private var spinner: UIView?

    typealias Auth = FIRAuthenticator
    typealias Profile = FIRProfileStorage

    private var uid: String?
    private var image: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.registerObserversForKeyboard()
        self.hideKeyboardWhenTappedAround()
    }

    override func viewWillAppear(_ animated: Bool) {
        Profile.getCustomerInfo(completion: getCustomerInfoComplete(customer:),
                                errorHandler: handleError(error:))
        spinner = showSpinner(onView: view)
        super.viewWillAppear(animated)
    }

    @IBAction private func handleBack(_ sender: Any) {
        handleBack()
    }

    @IBAction private func saveButton(_ sender: Any) {
        let trimmedName = nameTextField.text?.trimmingCharacters(in: .newlines)
        let trimmedContact = contactTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedEmail = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)

        guard checkIfAllFieldsAreFilled() else {
            showMessage(title: Constants.missingFieldsTitle,
                        message: Constants.missingFieldsMessage,
                        buttonText: Constants.okayTitle)
            return
        }

        guard let uid = uid, let name = trimmedName,
            let contact = trimmedContact, let email = trimmedEmail else {
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
            Profile.updateCustomerProfilePic(uid: uid, image: image, errorHandler: handleError(error:))
        }

        if let password = newPasswordTextField.text {
            changePassword(password)
        }

        let customer = Customer(uid: uid, name: name, email: email, contact: contact)

        Profile.updateCustomerInfo(customer: customer, completion: updateComplete, errorHandler: handleError(error:))
    }

    @objc func handleProfileTap(_ sender: UITapGestureRecognizer) {
        showImagePickerControllerActionSheet()
    }

    private func getCustomerInfoComplete(customer: Customer) {
        self.uid = customer.uid
        self.nameTextField.text = customer.name
        self.contactTextField.text = customer.contact
        self.emailTextField.text = customer.email

        setUpProfileImageView(uid: customer.uid)

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
                    buttonAction: { (_: UIAlertAction!) -> Void in
                        self.navigationController?.popViewController(animated: true) })
    }
    
    private func setUpProfileImageView(uid: String) {
        let profileTapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                                 action: #selector(self.handleProfileTap(_:)))
        profileImageView.addGestureRecognizer(profileTapGestureRecognizer)
        profileImageView.isUserInteractionEnabled = true

        Profile.getCustomerProfilePic(uid: uid, placeholder: profileImageView)
    }

    private func handleError(error: Error) {
        showMessage(title: Constants.errorTitle, message: error.localizedDescription, buttonText: Constants.okayTitle)
    }

    private func checkIfAllFieldsAreFilled() -> Bool {
        if let name = nameTextField.text,
            let contact = contactTextField.text,
            let email = emailTextField.text {
            return !name.trimmingCharacters(in: .newlines).isEmpty &&
                !contact.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
                !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        }
        return false
    }

}

extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func showImagePickerControllerActionSheet() {
        let photoLibraryAction = UIAlertAction(
            title: Constants.chooseFromPhotoLibraryTitle, style: .default
            ) { _ in self.showImagePickerController(sourceType: .photoLibrary) }
        let cameraAction = UIAlertAction(
            title: Constants.chooseFromCameraTitle, style: .default
            ) { _ in self.showImagePickerController(sourceType: .camera) }
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
            self.image = editedImage
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profileImageView.image = originalImage
            self.image = originalImage
        }
        dismiss(animated: true, completion: nil)
    }
}

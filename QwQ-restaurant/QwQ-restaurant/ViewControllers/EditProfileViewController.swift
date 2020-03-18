//
//  EditProfileViewController.swift
//  QwQ
//
//  Created by Daniel Wong on 14/3/20.
//

import UIKit

class EditProfileViewController: UIViewController, ProfileDelegate {

    @IBOutlet private var nameTextField: UITextField!
    @IBOutlet private var emailTextField: UITextField!
    @IBOutlet private var contactTextField: UITextField!
    @IBOutlet private var addressTextField: UITextField!
    @IBOutlet private var menuTextView: UITextView!

    @IBOutlet private var profileImageView: UIImageView!

    let profileStorage: ProfileStorage
    var uid: String?
    var isOpen: Bool?

    init() {
        profileStorage = FBProfileStorage()
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        profileStorage = FBProfileStorage()
        super.init(coder: coder)
    }
    
    @IBAction func handleBack(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        profileStorage.setDelegate(delegate: self)
        profileStorage.getRestaurantInfo()

        self.hideKeyboardWhenTappedAround()
        
        setUpProfileImageView()
    }

    func getRestaurantInfoComplete(restaurant: Restaurant) {
        self.uid = restaurant.uid
        self.nameTextField.text = restaurant.name
        self.emailTextField.text = restaurant.email
        self.contactTextField.text = restaurant.contact
        self.addressTextField.text = restaurant.address
        self.menuTextView.text = restaurant.menu
        self.isOpen = restaurant.isOpen
    }

    @objc func handleProfileTap(_ sender: UITapGestureRecognizer) {
        showImagePickerControllerActionSheet()
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
                        buttonText: Constants.okayTitle)
            return
        }

        guard let uid = uid, let name = trimmedName, let email = trimmedEmail, let contact = trimmedContact,
            let address = trimmedAddress, let menu = trimmedMenu, let isOpen = isOpen else {
                return
        }

        profileStorage.updateRestaurantInfo(restaurant: Restaurant(uid: uid,
                                                     name: name,
                                                     email: email,
                                                     contact: contact,
                                                     address: address,
                                                     menu: menu,
                                                     isOpen: isOpen))
    }

    func updateComplete() {
        let message = UIAlertController(title: Constants.successfulUpdateTitle,
                                        message: Constants.successfulUpdateMessage,
                                        preferredStyle: .alert)

        let closeDialogAction = UIAlertAction(title: Constants.okayTitle,
                                              style: .default) { (_: UIAlertAction!) -> Void in
            self.navigationController?.popViewController(animated: true)
        }
        message.addAction(closeDialogAction)

        self.present(message, animated: true)
    }

    func showMessage(title: String, message: String, buttonText: String) {
        let message = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let closeDialogAction = UIAlertAction(title: buttonText, style: .default)
        message.addAction(closeDialogAction)

        self.present(message, animated: true)
    }

    private func setUpProfileImageView() {
        let profileTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleProfileTap(_:)))
        profileImageView.addGestureRecognizer(profileTapGestureRecognizer)
        profileImageView.isUserInteractionEnabled = true
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
        let photoLibraryAction = UIAlertAction(title: Constants.chooseFromPhotoLibraryTitle, style: .default) {
            (action) in
            self.showImagePickerController(sourceType: .photoLibrary)
        }
        let cameraAction = UIAlertAction(title: Constants.chooseFromCameraTitle, style: .default) {
            (action) in
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            profileImageView.image = editedImage
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profileImageView.image = originalImage
        }
        dismiss(animated: true, completion: nil)
        
    }
    
}

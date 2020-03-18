//
//  EditProfileViewController.swift
//  QwQ
//
//  Created by Daniel Wong on 14/3/20.
//

import UIKit

class EditProfileViewController: UIViewController, ProfileDelegate {

    @IBOutlet private var nameTextField: UITextField!
    @IBOutlet private var addressTextField: UITextField!
    @IBOutlet private var emailTextField: UITextField!
    @IBOutlet private var profileImageView: UIImageView!
    @IBOutlet private var menuTextView: UITextView!

    let profileStorage: ProfileStorage
    var uid: String?

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

        self.hideKeyboardWhenTappedAround()
        
        setUpProfileImageView()
    }
    
    private func setUpProfileImageView() {
        let profileTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleProfileTap(_:)))
        profileImageView.addGestureRecognizer(profileTapGestureRecognizer)
        profileImageView.isUserInteractionEnabled = true
    }
    
    @objc func handleProfileTap(_ sender: UITapGestureRecognizer) {
        showImagePickerControllerActionSheet()
    }

    @IBAction private func saveButton(_ sender: Any) {
        let trimmedName = nameTextField.text?.trimmingCharacters(in: .newlines)
        let trimmedAddress = addressTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedEmail = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedMenu = menuTextView.text

        guard checkIfAllFieldsAreFilled() else {
            showMessage(title: Constants.missingFieldsTitle,
                        message: Constants.missingFieldsMessage,
                        buttonText: Constants.okayTitle)
            return
        }

        guard let uid = uid, let name = trimmedName,
            let address = trimmedAddress, let email = trimmedEmail, let menu = trimmedMenu else {
                return
        }

        profileStorage.update(restaurant: Restaurant(uid: uid, name: name, email: email, contact: <#T##String#>, address: address, menu: menu, isOpen: <#T##Bool#>))
    }

    func getCustomerInfoComplete(customer: Customer) {
        self.uid = customer.uid
        self.nameTextField.text = customer.name
        self.contactTextField.text = customer.contact
        self.emailTextField.text = customer.email
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

    private func checkIfAllFieldsAreFilled() -> Bool {
        if let name = nameTextField.text,
            let address = addressTextField.text,
            let email = emailTextField.text,
            let menu = menuTextView.text {
            return !name.trimmingCharacters(in: .newlines).isEmpty &&
                !address.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
                !email.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
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

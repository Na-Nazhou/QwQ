//
//  FBProfileStorage.swift
//  QwQ
//
//  Created by Daniel Wong on 14/3/20.
//

import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage
import FirebaseUI
import SDWebImage

class FBProfileStorage: ProfileStorage {

    private weak var delegate: ProfileDelegate?

    let storageRef: StorageReference

    init() {
        self.storageRef = Storage.storage().reference().child("profile-pics")
    }

    func setDelegate(delegate: ProfileDelegate) {
        self.delegate = delegate
    }

    func getCustomerInfo() {
        let db = Firestore.firestore()
        guard let user = Auth.auth().currentUser else {
            return
        }
        let docRef = db.collection("customers").document(user.uid)

        docRef.getDocument { (document, error) in
            if let error = error {
                self.delegate?.showMessage(title: "Error!", message: error.localizedDescription,
                                           buttonText: Constants.okayTitle, buttonAction: nil)
            }
            if let data = document?.data() {
                guard let customer = Customer(dictionary: data) else {
                    self.delegate?.showMessage(title: "Error!", message: "A fatal error occured.",
                                               buttonText: Constants.okayTitle, buttonAction: nil)
                    return
                }
                self.delegate?.getCustomerInfoComplete(customer: customer)
            }
        }
    }

    func getCustomerProfilePic(uid: String, placeholder imageView: UIImageView) {
        let reference = storageRef.child("\(uid).png")
        guard let image = imageView.image else {
            return
        }
        imageView.checkCacheThenSetImage(with: reference, placeholder: image)
    }

    func updateCustomerInfo(customer: Customer) {
        let db = Firestore.firestore()
        guard let user = Auth.auth().currentUser else {
            return
        }
        let docRef = db.collection("customers").document(user.uid)

        docRef.updateData(customer.dictionary) { (error) in
            if let error = error {
                self.delegate?.showMessage(title: "Error:", message: error.localizedDescription,
                                           buttonText: Constants.okayTitle, buttonAction: nil)
                return
            }
            CustomerPostLoginSetupManager.customerDidUpdateProfile(updated: customer)
            self.delegate?.updateComplete()
        }
    }

    func updateCustomerProfilePic(uid: String, image: UIImage) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            delegate?.showMessage(title: "Error",
                                  message: "Invalid or no image selected.",
                                  buttonText: "Okay",
                                  buttonAction: nil)
            return
        }
        storageRef.child("\(uid).png").putData(imageData, metadata: nil) { (_, error) in
            if let error = error {
                self.delegate?.showMessage(title: "Error",
                                           message: error.localizedDescription,
                                           buttonText: "Okay",
                                           buttonAction: nil)
                return
            }
        }
    }

}

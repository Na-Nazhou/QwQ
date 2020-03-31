//
//  EmailVerificationViewController.swift
//  QwQ
//
//  Created by Tan Su Yee on 25/3/20.
//

import UIKit

class EmailVerificationViewController: UIViewController {

    typealias Profile = FIRProfileStorage

    @IBOutlet private var emailLabel: UILabel!
    
    @IBAction private func handleBack(_ sender: Any) {
        performSegue(withIdentifier: "goToLogin", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.emailLabel.text = Profile.currentUID
    }
}

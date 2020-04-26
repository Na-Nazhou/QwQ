//
//  EmailVerificationViewController.swift
//  QwQ
//
//  Created by Tan Su Yee on 25/3/20.
//

/**
`EmailVerificationViewController` manages verification of email when a user signs up.
*/

import UIKit

class EmailVerificationViewController: UIViewController {

    // MARK: View properties
    @IBOutlet private var emailLabel: UILabel!

    typealias Profile = FIRProfileStorage
    
    @IBAction private func handleBack(_ sender: Any) {
        performSegue(withIdentifier: Constants.emailVerificationCancelledSegue, sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.emailLabel.text = Profile.currentUID
    }
}

//
//  EmailVerificationViewController.swift
//  QwQ-restaurant
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction private func handleBack(_ sender: Any) {
        handleBack()
    }
}

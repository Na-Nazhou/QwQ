//
//  UIViewController+ShowMessage.swift
//  QwQ
//
//  Created by Daniel Wong on 18/3/20.
//

import UIKit

extension UIViewController {
    func showMessage(title: String, message: String, buttonText: String,
                     buttonAction: ((UIAlertAction) -> Void)?) {
        let message = UIAlertController(title: title, message: message, preferredStyle: .alert)

        let action = UIAlertAction(title: buttonText, style: .default, handler: buttonAction)
        message.addAction(action)

        self.present(message, animated: true)
    }
}

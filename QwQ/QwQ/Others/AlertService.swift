//
//  AlertService.swift
//  QwQ
//
//  Created by Tan Su Yee on 15/3/20.
//

import UIKit

class AlertService {
    
    static func showAlert(style: UIAlertController.Style,
                          title: String?, message: String?,
                          actions: [UIAlertAction] = [UIAlertAction(title: Constants.okayTitle,
                                                                    style: .cancel,
                                                                    handler: nil)],
                          completion: (() -> Swift.Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        for action in actions {
            alert.addAction(action)
        }
        if let topVC = UIApplication.getTopMostViewController() {
            alert.popoverPresentationController?.sourceView = topVC.view
            alert.popoverPresentationController?.sourceRect =
                CGRect(x: topVC.view.bounds.midX, y: topVC.view.bounds.midY, width: 0, height: 0)
            alert.popoverPresentationController?.permittedArrowDirections = []
            topVC.present(alert, animated: true, completion: completion)
        }
    }
    
}

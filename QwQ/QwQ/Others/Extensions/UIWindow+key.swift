//
//  UIWindow+key.swift
//  QwQ
//
//  Created by Nazhou Na on 21/4/20.
//

import UIKit

// Reference:
// https://stackoverflow.com/questions/57134259/how-to-resolve-keywindow-was-deprecated-in-ios-13-0

extension UIWindow {
    static var key: UIWindow? {
        if #available(iOS 13, *) {
            return UIApplication.shared.windows.first { $0.isKeyWindow }
        } else {
            return UIApplication.shared.keyWindow
        }
    }
}

//
//  UIButton+Extension.swift
//  QwQ
//
//  Created by Nazhou Na on 22/4/20.
//

import UIKit

extension UIButton {

    func enable() {
        isEnabled = true
        alpha = 1
    }

    func disable() {
        isEnabled = false
        alpha = 0.5
    }
}

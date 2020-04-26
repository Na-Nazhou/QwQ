//
//  LoginUtilities.swift
//  QwQ
//
//  Created by Daniel Wong on 14/3/20.
//

import Foundation

class ValidationUtilities {

    /// Taken from https://emailregex.com/
    static func validateEmail(email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email)
    }

    /// Return true if contact is all digits and 8 character length
    static func validateContact(contact: String) -> Bool {
        isAllDigits(text: contact) && contact.count == 8
    }

    /// Adapted from https://gist.github.com/ranmyfriend/96f6ae1b64b177af62de402c6898a314
    private static func isAllDigits(text: String) -> Bool {
        let characterSet = NSCharacterSet(charactersIn: "0123456789").inverted
        let inputString = text.components(separatedBy: characterSet)
        let filtered = inputString.joined()
        return text == filtered
    }

}

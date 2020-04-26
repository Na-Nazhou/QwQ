//
//  FormattingUtilities.swift
//  QwQ-restaurant
//
//  Created by Daniel Wong on 20/4/20.
//

import Foundation

class FormattingUtilities {
    static func convertAnyToStringArray(_ anyArray: [Any]) -> [String] {
        var result = [String]()
        for item in anyArray {
            if let item = item as? String {
                result.append(item)
            }
        }
        return result
    }
}

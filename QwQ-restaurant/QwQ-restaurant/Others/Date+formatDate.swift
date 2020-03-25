//
//  Date+formatDate.swift
//  QwQ-restaurant
//
//  Created by Tan Su Yee on 25/3/20.
//

import Foundation

extension Date {
    static func getFormattedDate(date: Date, format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: date)
    }
}

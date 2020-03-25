//
//  Date+Extensions.swift
//  QwQ
//
//  Created by Happy on 19/3/20.
//

import Foundation

extension Date {
    func getDateOf(daysBeforeDate numDays: Int) -> Date {
        let dayComponent = DateComponents(day: -numDays)
        let date = Calendar.current.date(byAdding: dayComponent, to: self) ?? self
        return date
    }

    func toString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter.string(from: self)
    }
    
    static func getFormattedDate(date: Date, format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: date)
    }
}

//
//  Date+Extensions.swift
//  QwQ
//
//  Created by Happy on 19/3/20.
//

import Foundation

extension Date {
    func getDateOf(daysBeforeDate numDays: Int) -> Date {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: self)
        let dayComponent = DateComponents(day: -numDays)
        let date = calendar.date(byAdding: dayComponent, to: startOfDay) ?? self
        return date
    }

    func toString() -> String {
        Self.getFormattedDate(date: self, format: "yyyy-MM-dd HH:mm")
    }

    func getFormattedTime() -> String {
        Self.getFormattedDate(date: self, format: "HH:mm")
    }
    
    static func getFormattedDate(date: Date, format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: date)
    }
}

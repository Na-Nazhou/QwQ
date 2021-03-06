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
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter.string(from: self)
    }

    func getFormattedTime() -> String {
        Self.getFormattedDate(date: self, format: "HH:mm")
    }

    static func getFormattedTime(_ interval: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.zeroFormattingBehavior = .pad
        formatter.allowedUnits = [.hour, .minute]
        return formatter.string(from: interval) ?? ""
    }
    
    static func getFormattedDate(date: Date, format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: date)
    }

    static func getCurrentTime() -> Date {
        let calendar = Calendar.current
        let currentTime = calendar.date(bySetting: .second, value: 0, of: Date())!
        return currentTime
    }

    static func getStartOfDay(of date: Date) -> Date {
        Calendar.current.startOfDay(for: date)
    }
}

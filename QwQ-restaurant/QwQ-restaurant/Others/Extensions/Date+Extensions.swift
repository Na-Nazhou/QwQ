//
//  Date+Extensions.swift
//  QwQ
//
//  Created by Happy on 19/3/20.
//

import Foundation

extension Date {

    static let minute: TimeInterval = 60.0
    static let hour: TimeInterval = 60.0 * minute
    static let day: TimeInterval = 24 * hour

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

    static func getFormattedTime(_ interval: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.zeroFormattingBehavior = .pad
        formatter.allowedUnits = [.hour, .minute]
        return formatter.string(from: interval) ?? ""
    }

    static func getTimeIntervalFromStartOfDay(_ date: Date) -> TimeInterval {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        let time = calendar.date(from: components)!
        return time.timeIntervalSince(Date.getStartOfDay(of: time))
    }

    func getFomattedDate() -> String {
        Self.getFormattedDate(date: self, format: "yyyy-MM-dd")
    }
    
    static func getFormattedDate(date: Date, format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: date)
    }

    static func isSameDay(date1: Date, date2: Date) -> Bool {
        let diff = Calendar.current.dateComponents([.day], from: date1, to: date2)
        return diff.day == 0
    }

    static func getEndOfDay(of date: Date) -> Date {
        let calendar = Calendar.current
        let endTime = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: date)
        return endTime!
    }

    static func getStartOfDay(of date: Date) -> Date {
        Calendar.current.startOfDay(for: date)
    }

    static func getMonday(of date: Date) -> Date {
        let calendar = Calendar.current
        var comps = calendar.dateComponents([.weekOfYear, .yearForWeekOfYear], from: date)
        comps.weekday = 2 // Monday
        let mondayInWeek = calendar.date(from: comps)!
        return mondayInWeek
    }
}

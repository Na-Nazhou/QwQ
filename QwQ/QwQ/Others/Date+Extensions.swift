//
//  Date+Extensions.swift
//  QwQ
//
//  Created by Happy on 19/3/20.
//

import Foundation

extension Date {
    func toDateStringWithoutTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "ddMMyyyy"
        return formatter.string(from: self)
    }

    func getDateOf(daysBeforeDate numDays: Int) -> Date {
        let dayComponent = DateComponents(day: -numDays)
        return Calendar.current.date(byAdding: dayComponent, to: self) ?? self
    }
}

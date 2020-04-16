//
//  Collection+Statistics.swift
//  QwQ-restaurant
//
//  Created by Nazhou Na on 15/4/20.
//

import Foundation

extension Collection where T == Statistics {

    var statistics: [Statistics] {
        Array(elements).sorted(by: {
            $0.fromDate > $1.fromDate
        })
    }

    func addOrUpdate(_ stats: Statistics) {
        if !add(stats) {
            update(stats)
        }
    }

    var fromDate: Date? {
        statistics.last?.fromDate
    }

    var toDate: Date? {
         statistics.first?.toDate
    }
}

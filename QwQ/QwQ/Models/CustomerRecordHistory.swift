//
//  CustomerRecordHistory.swift
//  QwQ
//
//  Created by Nazhou Na on 22/3/20.
//

class CustomerRecordHistory {

    var queueHistory: CustomerQueueHistory
    var bookingHistory: CustomerBookingHistory

    var historyRecords: [Record] {
        var records = [Record]()
        records.append(contentsOf: Array(queueHistory.history))
        records.append(contentsOf: Array(bookingHistory.history))
        return records
    }

    init(queueHistory: CustomerQueueHistory,
         bookingHistory: CustomerBookingHistory) {
        self.queueHistory = queueHistory
        self.bookingHistory = bookingHistory
    }
}

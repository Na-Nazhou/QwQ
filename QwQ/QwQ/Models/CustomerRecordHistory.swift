//
//  CustomerRecordHistory.swift
//  QwQ
//
//  Created by Nazhou Na on 22/3/20.
//

class CustomerRecordHistory {

    var queueHistory: CustomerHistory<QueueRecord>
    var bookingHistory: CustomerHistory<BookRecord>

    var historyRecords: [Record] {
        var records = [Record]()
        records.append(contentsOf: Array(queueHistory.history))
        records.append(contentsOf: Array(bookingHistory.history))
        return records
    }

    init(queueHistory: CustomerHistory<QueueRecord>,
         bookingHistory: CustomerHistory<BookRecord>) {
        self.queueHistory = queueHistory
        self.bookingHistory = bookingHistory
    }
}

//
//  CustomerRecordHistory.swift
//  QwQ
//
//  Created by Nazhou Na on 22/3/20.
//

class CustomerHistory {

    var queueHistory: RecordHistory<QueueRecord>
    var bookingHistory: RecordHistory<BookRecord>

    var historyRecords: [Record] {
        var records = [Record]()
        records.append(contentsOf: Array(queueHistory.history))
        records.append(contentsOf: Array(bookingHistory.history))
        return records
    }

    init(queueHistory: RecordHistory<QueueRecord>,
         bookingHistory: RecordHistory<BookRecord>) {
        self.queueHistory = queueHistory
        self.bookingHistory = bookingHistory
    }
}

//
//  CustomerRecordHistory.swift
//  QwQ
//
//  Created by Nazhou Na on 22/3/20.
//

class CustomerHistory {

    var queueHistory: RecordCollection<QueueRecord>
    var bookingHistory: RecordCollection<BookRecord>

    var historyRecords: [Record] {
        var records = [Record]()
        records.append(contentsOf: queueHistory.records)
        records.append(contentsOf: bookingHistory.records)
        return records
    }

    init(queueHistory: RecordCollection<QueueRecord>,
         bookingHistory: RecordCollection<BookRecord>) {
        self.queueHistory = queueHistory
        self.bookingHistory = bookingHistory
    }
}

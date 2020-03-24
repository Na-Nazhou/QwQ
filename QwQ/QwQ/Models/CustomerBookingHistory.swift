//
//  CustomerBookingHistory.swift
//  QwQ
//
//  Created by Nazhou Na on 22/3/20.
//

class CustomerBookingHistory {
    private(set) var history = Set<BookRecord>()

    var size: Int {
        history.count
    }

    func addToHistory(_ bookRecord: BookRecord) -> Bool {
        let (isNew, _) = history.insert(bookRecord)
        return isNew
    }

    func addToHistory(_ records: [BookRecord]) -> Bool {
        let origSize = size
        history = history.union(Set(records))
        return size > origSize
    }

    func resetHistory() {
        history.removeAll()
    }
}

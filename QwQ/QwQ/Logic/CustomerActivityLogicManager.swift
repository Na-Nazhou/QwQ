//
//  CustomerActivityLogicManager.swift
//  QwQ
//
//  Created by Nazhou Na on 9/4/20.
//

import Foundation

class CustomerActivityLogicManager: CustomerActivityLogic {

    // Models
    private let customerActivity: CustomerActivity

    init() {
        self.customerActivity = CustomerActivity.shared()
    }

    func fetchActiveRecords() -> [Record] {
        customerActivity.activeRecords.sorted(by: { record1, record2 in
            let time1: Date
            let time2: Date
            if let queueRecord1 = record1 as? QueueRecord {
                time1 = queueRecord1.startTime
            } else {
                time1 = (record1 as? BookRecord)!.time
            }
            if let queueRecord2 = record2 as? QueueRecord {
                time2 = queueRecord2.startTime
            } else {
                time2 = (record2 as? BookRecord)!.time
            }
            return time1 > time2
        })
    }

    func fetchHistoryRecords() -> [Record] {
        customerActivity.historyRecords.sorted(by: { record1, record2 in
            let time1: Date
            let time2: Date
            if record1.isServed {
                time1 = record1.serveTime!
            } else if record1.isRejected {
                time1 = record1.rejectTime!
            } else {
                time1 = record1.withdrawTime!
            }
            if record2.isServed {
                time2 = record2.serveTime!
            } else if record2.isRejected {
                time2 = record2.rejectTime!
            } else {
                time2 = record2.withdrawTime!
            }
            return time1 > time2
        })
    }
}

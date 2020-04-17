//
//  CustomerRecordLogicManager.swift
//  QwQ
//
//  Created by Nazhou Na on 17/4/20.
//

import Foundation
import os.log

class CustomerRecordLogicManager<T: Record & Hashable> {

    // View Controllers
    weak var activitiesDelegate: ActivitiesDelegate?

    func didAddRecord(_ record: T,
                      _ activeList: RecordCollection<T>,
                      _ historyList: RecordCollection<T>) {
        if record.isActiveRecord {
            addRecord(record, to: activeList)
        }
        if record.isHistoryRecord {
            addRecord(record, to: historyList)
        }
    }

    func customerDidUpdateRecord(_ record: T,
                                 _ activeList: RecordCollection<T>) {
        os_log("Detected regular modification", log: Log.regularModification, type: .info)
        if record.isActiveRecord && activeList.update(record) {
            activitiesDelegate?.didUpdateActiveRecords()
        }
    }

    func didConfirmRecord(_ record: T,
                          _ activeList: RecordCollection<T>) {
        os_log("Detected confirmation", log: Log.confirmedByCustomer, type: .info)
        if record.isActiveRecord && activeList.update(record) {
            activitiesDelegate?.didUpdateActiveRecords()
        }
    }

    func didWithdrawRecord(_ record: T,
                           _ activeList: RecordCollection<T>,
                           _ historyList: RecordCollection<T>) {
        os_log("Detected withdrawal", log: Log.withdrawnByCustomer, type: .info)
        removeRecord(record, from: activeList)
        addRecord(record, to: historyList)
    }

    func didServeRecord(_ record: T,
                        _ activeList: RecordCollection<T>,
                        _ historyList: RecordCollection<T>) {
        os_log("Detected service", log: Log.serveCustomer, type: .info)
        removeRecord(record, from: activeList)
        addRecord(record, to: historyList)
    }

    func didRejectRecord(_ record: T,
                         _ activeList: RecordCollection<T>,
                         _ historyList: RecordCollection<T>) {
        os_log("Detected rejection", log: Log.rejectCustomer, type: .info)
        removeRecord(record, from: activeList)
        addRecord(record, to: historyList)
    }

    func addRecord(_ record: T, to collection: RecordCollection<T>) {
        if record.isActiveRecord && collection.add(record) {
            activitiesDelegate?.didUpdateActiveRecords()
        }
        if record.isHistoryRecord && collection.add(record) {
            activitiesDelegate?.didUpdateHistoryRecords()
        }
    }

    func removeRecord(_ record: T, from collection: RecordCollection<T>) {
        if record.isActiveRecord && collection.remove(record) {
            activitiesDelegate?.didUpdateActiveRecords()
        }
        if record.isHistoryRecord && collection.remove(record) {
            activitiesDelegate?.didUpdateHistoryRecords()
        }
    }

    func getUpdatedRecord<T: Record>(record: T, event: RecordModification) -> T {
        var new = record
        let time = Date()
        switch event {
        case .withdraw:
            new.withdrawTime = time
        default:
            assert(false)
        }
        return new
    }
}

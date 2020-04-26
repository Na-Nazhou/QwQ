import Foundation
import os.log

/// A generic customer record logic manager.
class CustomerRecordLogicManager<T: Record & Hashable> {

    // View Controllers
    weak var activitiesDelegate: ActivitiesDelegate?
    
    /// Adds `record` to the corresponding list based on its status.
    func didAddRecord(_ record: T,
                      _ activeList: RecordCollection<T>,
                      _ missedList: RecordCollection<T>,
                      _ historyList: RecordCollection<T>) {
        if record.isMissedAndPending {
            addRecord(record, to: missedList)
        } else if record.isActiveRecord {
            addRecord(record, to: activeList)
        }
        if record.isHistoryRecord {
            addRecord(record, to: historyList)
        }
    }

    /// Updates `record` in its list.
    func customerDidUpdateRecord(_ record: T,
                                 _ activeList: RecordCollection<T>,
                                 _ missedList: RecordCollection<T>,
                                 _ historyList: RecordCollection<T>) {
        os_log("Detected regular modification", log: Log.regularModification, type: .info)
        updateRecord(record, in: missedList)
        updateRecord(record, in: activeList)
        updateRecord(record, in: historyList)
    }

    func didConfirmRecord(_ record: T,
                          _ activeList: RecordCollection<T>) {
        os_log("Detected confirmation", log: Log.confirmedByCustomer, type: .info)
        updateRecord(record, in: activeList)
    }

    /// Removes `record` from `activeList` and adds to `historyList`.
    func didWithdrawRecord(_ record: T,
                           _ activeList: RecordCollection<T>,
                           _ historyList: RecordCollection<T>) {
        os_log("Detected withdrawal", log: Log.withdrawnByCustomer, type: .info)
        removeRecord(record, from: activeList)
        addRecord(record, to: historyList)
    }

    /// Serves `record` and removes from `activeList` and adds to `historyList`.
    func didServeRecord(_ record: T,
                        _ activeList: RecordCollection<T>,
                        _ historyList: RecordCollection<T>) {
        os_log("Detected service", log: Log.serveCustomer, type: .info)
        removeRecord(record, from: activeList)
        addRecord(record, to: historyList)
    }
    
    /// Rejects `record` and removes from `activeList` and adds to `historyList`.
    func didRejectRecord(_ record: T,
                         _ activeList: RecordCollection<T>,
                         _ historyList: RecordCollection<T>) {
        os_log("Detected rejection", log: Log.rejectCustomer, type: .info)
        removeRecord(record, from: activeList)
        addRecord(record, to: historyList)
    }

    /// Adds `record` to `collection` and updates the presentation.
    func addRecord(_ record: T, to collection: RecordCollection<T>) {
        collection.add(record)
        if record.isMissedAndPending {
            activitiesDelegate?.didUpdateMissedRecords()
            return
        }
        if record.isActiveRecord {
            activitiesDelegate?.didUpdateActiveRecords()
        }
        if record.isHistoryRecord {
            activitiesDelegate?.didUpdateHistoryRecords()
        }
    }
    
    /// Removes `record` from `collection` and updates the presentation.
    func removeRecord(_ record: T, from collection: RecordCollection<T>) {
        collection.remove(record)
        activitiesDelegate?.didUpdateActiveRecords()
        activitiesDelegate?.didUpdateMissedRecords()
        activitiesDelegate?.didUpdateHistoryRecords()
    }
    
    /// Updates `record` in `collection` and updates the presentation.
    func updateRecord(_ record: T, in collection: RecordCollection<T>) {
        collection.update(record)
        activitiesDelegate?.didUpdateActiveRecords()
        activitiesDelegate?.didUpdateMissedRecords()
        activitiesDelegate?.didUpdateHistoryRecords()
    }
    
    /// Updates and returns a copy of `record` updated to `event` at the current time.
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

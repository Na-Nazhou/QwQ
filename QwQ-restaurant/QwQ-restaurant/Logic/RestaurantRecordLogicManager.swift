import Foundation

/// A generic restaurant record logic manager.
class RestaurantRecordLogicManager<T: Record & Hashable> {

    // View Controller
    weak var activitiesDelegate: ActivitiesDelegate?

    /// Adds `record` to the corresponding list based on its status.
    func didAddRecord(_ record: T,
                      _ currentList: RecordCollection<T>,
                      _ waitingList: RecordCollection<T>,
                      _ historyList: RecordCollection<T>) {
        if record.isPendingAdmission || record.isMissedAndPending {
            if addRecord(record, to: currentList) {
                self.activitiesDelegate?.didUpdateCurrentList()
            }
        }

        if record.isAdmitted || record.isConfirmedAdmission {
            if addRecord(record, to: waitingList) {
                self.activitiesDelegate?.didUpdateWaitingList()
            }
        }

        if record.isHistoryRecord {
            if addRecord(record, to: historyList) {
                self.activitiesDelegate?.didUpdateHistoryList()
            }
        }
    }

    private func addRecord(_ record: T, to collection: RecordCollection<T>) -> Bool {
        collection.add(record)
    }

    /// Updates the record in its list.
    func didUpdateRecord(_ record: T,
                         _ currentList: RecordCollection<T>,
                         _ waitingList: RecordCollection<T>,
                         _ historyList: RecordCollection<T>) {
        if record.isPendingAdmission {
            didCustomerUpdateRecord(record, currentList)
        }

        if record.isMissedAndPending {
            didMissRecord(record, currentList, waitingList)
        }

        if record.isAdmitted {
            didAdmitRecord(record, currentList, waitingList)
        }

        if record.isConfirmedAdmission {
            didConfirmRecord(record, currentList, waitingList)
        }

        if record.isHistoryRecord {
            didArchiveRecord(record, currentList, waitingList, historyList)
        }
    }

    private func didCustomerUpdateRecord(_ record: T, _ currentList: RecordCollection<T>) {
        currentList.update(record)
        activitiesDelegate?.didUpdateCurrentList()
    }

    private func didMissRecord(_ record: T,
                               _ currentList: RecordCollection<T>,
                               _ waitingList: RecordCollection<T>) {
        assert(record as? BookRecord == nil, "Book records are not missable.")
        if waitingList.remove(record) {
            activitiesDelegate?.didUpdateWaitingList()
        }
        if currentList.add(record) {
            activitiesDelegate?.didUpdateCurrentList()
        }
    }

    private func didAdmitRecord(_ record: T,
                                _ currentList: RecordCollection<T>,
                                _ waitingList: RecordCollection<T>) {
        if currentList.remove(record) {
            activitiesDelegate?.didUpdateCurrentList()
        }
        if waitingList.add(record) {
            activitiesDelegate?.didUpdateWaitingList()
        }
    }

    private func didConfirmRecord(_ record: T,
                                  _ currentList: RecordCollection<T>,
                                  _ waitingList: RecordCollection<T>) {
        if currentList.remove(record) {
            activitiesDelegate?.didUpdateCurrentList()
        }
        if waitingList.add(record) {
            activitiesDelegate?.didUpdateWaitingList()
        }
        if waitingList.update(record) {
            activitiesDelegate?.didUpdateWaitingList()
        }
    }

    private func didArchiveRecord(_ record: T,
                                  _ currentList: RecordCollection<T>,
                                  _ waitingList: RecordCollection<T>,
                                  _ historyList: RecordCollection<T>) {
        if currentList.remove(record) {
            activitiesDelegate?.didUpdateCurrentList()
        }

        if waitingList.remove(record) {
            activitiesDelegate?.didUpdateWaitingList()
        }

        if historyList.add(record) {
            activitiesDelegate?.didUpdateHistoryList()
        }
    }

    /// Updates and returns a copy of `record` updated to `event` at the current time.
    func getUpdatedRecord(record: T, event: RecordModification) -> T {
        var new = record
        let time = Date()
        switch event {
        case .admit:
            new.admitTime = time
        case .readmit:
            new.readmitTime = time
        case .serve:
            new.serveTime = time
        case .reject:
            new.rejectTime = time
        case .miss:
            new.missTime = time
        default:
            assert(false)
        }
        return new
    }
}

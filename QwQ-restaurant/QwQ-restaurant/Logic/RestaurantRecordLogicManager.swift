//
//  RestaurantRecordLogicManager.swift
//  QwQ-restaurant
//
//  Created by Nazhou Na on 17/4/20.
//

import Foundation

class RestaurantRecordLogicManager {

    // View Controller
    weak var activitiesDelegate: ActivitiesDelegate?

    func didAddRecord<T: Record>(_ record: T,
                                 currentList: RecordCollection<T>,
                                 waitingList: RecordCollection<T>,
                                 historyList: RecordCollection<T>) {
        if record.isPendingAdmission {
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

    private func addRecord<T: Record>(_ record: T, to collection: RecordCollection<T>) -> Bool {
        collection.add(record)
    }

    func didUpdateRecord<T: Record>(_ record: T,
                                    currentList: RecordCollection<T>,
                                    waitingList: RecordCollection<T>,
                                    historyList: RecordCollection<T>) {
        if record.isPendingAdmission {
            didCustomerUpdateRecord(record, currentList)
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

    func didCustomerUpdateRecord<T: Record>(_ record: T, _ currentList: RecordCollection<T>) {
        currentList.update(record)
        activitiesDelegate?.didUpdateCurrentList()
    }

    private func didAdmitRecord<T: Record>(_ record: T,
                                           _ currentList: RecordCollection<T>,
                                           _ waitingList: RecordCollection<T>) {
        if currentList.remove(record) {
            activitiesDelegate?.didUpdateCurrentList()
        }
        if waitingList.add(record) {
            activitiesDelegate?.didUpdateWaitingList()
        }
    }

    private func didConfirmRecord<T: Record>(_ record: T,
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

    private func didArchiveRecord<T: Record>(_ record: T,
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

    func getUpdatedRecord<T: Record>(record: T, event: RecordModification) -> T {
        var new = record
        let time = Date()
        switch event {
        case .admit:
            new.admitTime = time
        case .serve:
            new.serveTime = time
        case .reject:
            new.rejectTime = time
        default:
            assert(false)
        }
        return new
    }
}

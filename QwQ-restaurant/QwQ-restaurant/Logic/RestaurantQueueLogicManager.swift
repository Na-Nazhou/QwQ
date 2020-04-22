//
//  RestaurantQueueLogicManager.swift
//  QwQ-restaurant
//
//  Created by Nazhou Na on 17/4/20.
//

import Foundation
import os.log

class RestaurantQueueLogicManager: RestaurantRecordLogicManager<QueueRecord>, RestaurantQueueLogic {

    // Storage
    private var queueStorage: RestaurantQueueStorage

    // Models
    private let restaurantActivity: RestaurantActivity
    private var restaurant: Restaurant {
        restaurantActivity.restaurant
    }
    private var currentQueue: RecordCollection<QueueRecord> {
        restaurantActivity.currentQueue
    }
    private var waitingQueue: RecordCollection<QueueRecord> {
        restaurantActivity.waitingQueue
    }
    private var historyQueue: RecordCollection<QueueRecord> {
        restaurantActivity.historyQueue
    }

    private var currentRecords: [Record] {
        RestaurantActivityLogicManager().currentRecords
    }
    private var currentQueueRecords: [QueueRecord] {
        currentRecords.compactMap({ $0 as? QueueRecord })
    }

    override init() {
        self.restaurantActivity = RestaurantActivity.shared()
        self.queueStorage = FIRQueueStorage.shared

        super.init()

        self.queueStorage.registerDelegate(self)
    }

    deinit {
        os_log("DEINITING queue logic manager", log: Log.deinitLogic, type: .info)
        queueStorage.unregisterDelegate(self)
    }

    func admitCustomer(record: QueueRecord, completion: @escaping () -> Void) {
        let new = getUpdatedRecord(record: record, event: .admit)
        updateQueueRecord(oldRecord: record, newRecord: new, completion: completion)

        // Update the estimatedAdmitTime for remaining current queue records
        var queueRecords = currentQueueRecords
        queueRecords.removeAll(where: { $0 == record })
        setEstimatedAdmitTime(for: queueRecords)
    }

    func serveCustomer(record: QueueRecord, completion: @escaping () -> Void) {
        let new = getUpdatedRecord(record: record, event: .serve)
        updateQueueRecord(oldRecord: record, newRecord: new, completion: completion)
    }

    func rejectCustomer(record: QueueRecord, completion: @escaping () -> Void) {
        let new = getUpdatedRecord(record: record, event: .reject)
        updateQueueRecord(oldRecord: record, newRecord: new, completion: completion)
    }

    func missCustomer(record: QueueRecord, completion: @escaping () -> Void) {
        let new = getUpdatedRecord(record: record, event: .miss)
        updateQueueRecord(oldRecord: record, newRecord: new, completion: completion)
    }

    private func updateQueueRecord(oldRecord: QueueRecord, newRecord: QueueRecord,
                                   completion: @escaping () -> Void) {
        queueStorage.updateRecord(oldRecord: oldRecord, newRecord: newRecord,
                                  completion: completion)
    }
}

extension RestaurantQueueLogicManager {

    // MARK: Syncing

    func didAddQueueRecord(_ record: QueueRecord) {
        didAddRecord(record, currentQueue, waitingQueue, historyQueue)

        setEstimatedAdmitTime(for: record)
    }

    private func setEstimatedAdmitTime(for records: [QueueRecord]) {
        for record in records {
            setEstimatedAdmitTime(for: record)
        }
    }

    private func setEstimatedAdmitTime(for record: QueueRecord) {
        var newRecord = record
        if record.isPendingAdmission {
            if let estimatedAdmitTime = getEstimatedAdmitTime(of: record) {
                newRecord.estimatedAdmitTime = estimatedAdmitTime
            }
            updateQueueRecord(oldRecord: record, newRecord: newRecord, completion: {})
        }
    }

    private func getQueueInFront(of newRecord: QueueRecord) -> Int {
        var count = 0
        for record in currentRecords {
            if let queueRecord = record as? QueueRecord {
                if queueRecord.startTime < newRecord.startTime {
                    count += 1
                }
            }
            if let bookRecord = record as? BookRecord {
                if bookRecord.time < newRecord.startTime {
                    count += 1
                }
            }
        }
        return count
    }

    private func getEstimatedAdmitTime(of record: QueueRecord) -> Date? {
        let queueSize = getQueueInFront(of: record)
        let waitingTimePerRecord = Constants.waitingTimePerQueueRecord

        if queueSize == 0 {
            // If this is the first record in the current record list
            if record.estimatedAdmitTime == nil {
                // If there is no existing estimate, set to 10 min after the current time
                return Calendar.current.date(byAdding: .minute,
                                             value: waitingTimePerRecord,
                                             to: Date())!
            } else if let estimatedAdmitTime = record.estimatedAdmitTime, estimatedAdmitTime < Date() {
                // If the estimated estimate is outdated, set to current time
                return Date()
            }
        } else {
            // For subsequent records, set estimate to number of ppl in front * 10min
            if let queueRecord = currentRecords[0] as? QueueRecord,
                let reference = queueRecord.estimatedAdmitTime {
                return Calendar.current.date(byAdding: .minute,
                                             value: queueSize * waitingTimePerRecord,
                                             to: reference)!
            }
            if let bookRecord = currentRecords[0] as? BookRecord {
                return Calendar.current.date(byAdding: .minute,
                                             value: queueSize * waitingTimePerRecord,
                                             to: bookRecord.time)!
            }
        }

        return nil
    }

    func didUpdateQueueRecord(_ record: QueueRecord) {
        if isAdmitModification(record) {
            addInitialAutoMissTimer(for: record)
        }

        didUpdateRecord(record, currentQueue, waitingQueue, historyQueue)
    }
}

// MARK: - Miss timers and miss penalties
extension RestaurantQueueLogicManager {

    private func isAdmitModification(_ record: QueueRecord) -> Bool {
        guard let oldRecord = currentQueue.find(record) else {
            return false
        }
        let change = record.getChangeType(from: oldRecord)
        if change != .admit && change != .readmit {
            return false
        }
        return true
    }

    private func isMissModification(_ record: QueueRecord) -> Bool {
        guard let oldRecord = waitingQueue.find(record) else {
            return false
        }
        if record.getChangeType(from: oldRecord) != .miss {
            return false
        }
        return true
    }

    private func addInitialAutoMissTimer(for qRecord: QueueRecord) {
        var refTime = qRecord.admitTime!
        if qRecord.readmitTime != nil {
            refTime = qRecord.readmitTime!
        }
        let confirmationTimer = Timer(
            fireAt: refTime.addingTimeInterval(60 * Constants.queueWaitConfirmTimeInMins),
            interval: 1, target: self,
            selector: #selector(handleInitialMissOrWaitTimer),
            userInfo: qRecord, repeats: false)
        RunLoop.main.add(confirmationTimer, forMode: .common)
    }

    @objc private func handleInitialMissOrWaitTimer(timer: Timer) {
        os_log("Initial miss timer triggered.", log: Log.missCustomer, type: .info)

        guard let record = timer.userInfo as? QueueRecord,
            let updatedRecord = waitingQueue.find(record) else {
                return
        }

        switch updatedRecord.status {
        case .admitted:
            if updatedRecord.wasOnceMissed {
                rejectCustomer(record: updatedRecord, completion: {})
                return
            }
            // missed for the first time: given second chance
            missCustomer(record: updatedRecord, completion: {})
        case .confirmedAdmission:
            addDelayedAutoMissTimer(for: updatedRecord)
        default:
            break
        }
    }

    private func addDelayedAutoMissTimer(for record: QueueRecord) {
        var refTime = record.admitTime!
        if record.readmitTime != nil {
            refTime = record.readmitTime!
        }
        let serveArrivalTimer = Timer(
            fireAt: refTime.addingTimeInterval(60 * Constants.queueWaitArrivalInMins),
            interval: 1, target: self,
            selector: #selector(handleDelayedMissTimer),
            userInfo: record, repeats: false)
        RunLoop.main.add(serveArrivalTimer, forMode: .common)
    }

    @objc private func handleDelayedMissTimer(timer: Timer) {
        os_log("Delayed miss timer triggered.", log: Log.missCustomer, type: .info)

        guard let record = timer.userInfo as? QueueRecord,
            let updatedRecord = waitingQueue.find(record) else {
                return
        }

        assert(updatedRecord.status == .confirmedAdmission)

        if updatedRecord.wasOnceMissed {
            rejectCustomer(record: updatedRecord, completion: {})
        } else {
            missCustomer(record: updatedRecord, completion: {})
        }
    }
    
}

//
//  RestaurantQueueLogicManager.swift
//  QwQ-restaurant
//
//  Created by Nazhou Na on 17/4/20.
//

import Foundation

class RestaurantQueueLogicManager: RestaurantRecordLogicManager<QueueRecord>, RestaurantQueueLogic {

    // Storage
    private var queueStorage: RestaurantQueueStorage

    // Models
    private let restaurantActivity: RestaurantActivity
    private var restaurant: Restaurant {
        restaurantActivity.restaurant
    }

    var currentRecords: [Record] {
        restaurantActivity.currentRecords
    }

    override init() {
        self.restaurantActivity = RestaurantActivity.shared()
        self.queueStorage = FIRQueueStorage.shared

        super.init()

        self.queueStorage.registerDelegate(self)
    }

    deinit {
        queueStorage.unregisterDelegate(self)
    }

    func admitCustomer(record: QueueRecord, completion: @escaping () -> Void) {
        let new = getUpdatedRecord(record: record, event: .admit)
        updateQueueRecord(oldRecord: record, newRecord: new, completion: completion)
        // Update estimated admit time
        // TODO
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
}

extension RestaurantQueueLogicManager {

    // MARK: Syncing

    func didAddQueueRecord(_ record: QueueRecord) {
        // Set estimated admit time
        // TODO: Assume average waiting time per customer is 10 minutes (replace with stats later)
        var newRecord = record
        if record.isPendingAdmission {
            let queueSize = getQueueInFront(of: record)

            if queueSize == 0 {
                newRecord.estimatedAdmitTime = Calendar.current.date(byAdding: .minute, value: 5, to: Date())!
            } else {
                if let queueRecord = currentRecords[0] as? QueueRecord,
                    let reference = queueRecord.estimatedAdmitTime {
                    newRecord.estimatedAdmitTime = Calendar.current.date(byAdding: .minute,
                                                                         value: queueSize * 10,
                                                                         to: reference)!
                }
                if let bookRecord = currentRecords[0] as? BookRecord {
                    newRecord.estimatedAdmitTime = Calendar.current.date(byAdding: .minute,
                                                                         value: queueSize * 10,
                                                                         to: bookRecord.time)!
                }
            }
            updateQueueRecord(oldRecord: record, newRecord: newRecord, completion: {})
        }

        didAddRecord(newRecord,
                     restaurantActivity.currentQueue,
                     restaurantActivity.waitingQueue,
                     restaurantActivity.historyQueue)
    }

    func didUpdateQueueRecord(_ record: QueueRecord) {
        if isAdmitModification(record) {
            addInitialAutoMissTimer(for: record)
        }
        didUpdateRecord(record,
                        restaurantActivity.currentQueue,
                        restaurantActivity.waitingQueue,
                        restaurantActivity.historyQueue)
    }
}

// MARK: - Miss timers and miss penalties
extension RestaurantQueueLogicManager {

    private func isAdmitModification(_ record: QueueRecord) -> Bool {
        guard let oldRecord = restaurantActivity.currentQueue.records.first(where: { $0 == record }) else {
            return false
        }
        let change = record.getChangeType(from: oldRecord)
        if change != .admit && change != .readmit {
            return false
        }
        return true
    }

    private func isMissModification(_ record: QueueRecord) -> Bool {
        guard let oldRecord = restaurantActivity.waitingQueue.records.first(where: { $0 == record }) else {
            return false
        }
        if record.getChangeType(from: oldRecord) != .miss {
            return false
        }
        return true
    }

    private func addInitialAutoMissTimer(for qRecord: QueueRecord) {
        let confirmationTimer = Timer(
            fireAt: qRecord.admitTime!.addingTimeInterval(60 * Constants.queueWaitConfirmTimeInMins),
            interval: 1, target: self,
            selector: #selector(handleInitialMissOrWaitTimer),
            userInfo: qRecord, repeats: false)
        RunLoop.main.add(confirmationTimer, forMode: .common)
    }

    @objc private func handleInitialMissOrWaitTimer(timer: Timer) {
        guard let record = timer.userInfo as? QueueRecord,
            restaurantActivity.waitingQueue.records.contains(record),
            let updatedRecord = restaurantActivity.waitingQueue.records.first(where: { $0 == record }) else {
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

    private func addDelayedAutoMissTimer(for qRecord: QueueRecord) {
        let serveArrivalTimer = Timer(
            fireAt: qRecord.admitTime!.addingTimeInterval(60 * Constants.queueWaitArrivalInMins),
            interval: 1, target: self,
            selector: #selector(handleDelayedMissTimer),
            userInfo: qRecord, repeats: false)
        RunLoop.main.add(serveArrivalTimer, forMode: .common)
    }

    @objc private func handleDelayedMissTimer(timer: Timer) {
        guard let record = timer.userInfo as? QueueRecord,
            restaurantActivity.waitingQueue.records.contains(record),
            let updatedRecord = restaurantActivity.waitingQueue.records.first(where: { $0 == record }) else {
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

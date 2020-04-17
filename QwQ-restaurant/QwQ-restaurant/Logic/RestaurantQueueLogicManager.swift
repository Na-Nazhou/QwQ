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
        didUpdateRecord(record,
                        restaurantActivity.currentQueue,
                        restaurantActivity.waitingQueue,
                        restaurantActivity.historyQueue)
    }
}

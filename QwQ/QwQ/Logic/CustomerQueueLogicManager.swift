import Foundation
import os.log

class CustomerQueueLogicManager: CustomerQueueLogic {
    // Storage
    var queueStorage: CustomerQueueStorage

    // View Controller
    weak var queueDelegate: QueueDelegate?
    weak var activitiesDelegate: ActivitiesDelegate?

    private let customerActivity: CustomerActivity
    private var customer: Customer {
        customerActivity.customer
    }

    var currentQueueRecords: [QueueRecord] {
        customerActivity.currentQueues.records
    }
    var pastQueueRecords: [QueueRecord] {
        customerActivity.queueHistory.records
    }

    convenience init() {
        self.init(customerActivity: CustomerActivity.shared(),
                  queueStorage: FIRQueueStorage.shared)
    }

    // Constructor to provide flexibility for testing.
    init(customerActivity: CustomerActivity, queueStorage: CustomerQueueStorage) {
        self.customerActivity = customerActivity
        self.queueStorage = queueStorage

        self.queueStorage.registerDelegate(self)

        fetchActiveQueueRecords()
        fetchQueueHistory()
    }

    deinit {
        os_log("DEINITING queue lm", log: Log.deinitLogic, type: .info)
        queueStorage.unregisterDelegate(self)
    }

    private func fetchActiveQueueRecords() {
        if !currentQueueRecords.isEmpty {
            os_log("Active queue records already loaded.", log: Log.loadActivity, type: .info)
            return //already loaded, no need to reload.
        }
        queueStorage.loadActiveQueueRecords(customer: customer, completion: {
            guard let queueRecord = $0 else {
                return
            }
            self.didAddQueueRecord(queueRecord)
        })
    }

    func fetchQueueHistory() {
        if !pastQueueRecords.isEmpty {
            os_log("History queue records already loaded", log: Log.loadActivity, type: .info)
            return
        }
        queueStorage.loadQueueHistory(customer: customer, completion: {
            guard let record = $0 else {
                return
            }
            self.didAddQueueRecord(record)
        })
    }

    func canQueue(for restaurant: Restaurant) -> Bool {
        // add any other queueing restrictions here
        restaurant.isQueueOpen
            && currentQueueRecords.allSatisfy { $0.restaurant != restaurant }
    }

    func enqueue(to restaurant: Restaurant,
                 with groupSize: Int,
                 babyChairQuantity: Int,
                 wheelchairFriendly: Bool) -> Bool {
        let startTime = Date()
        let newRecord = QueueRecord(restaurant: restaurant,
                                    customer: customer,
                                    groupSize: groupSize,
                                    babyChairQuantity: babyChairQuantity,
                                    wheelchairFriendly: wheelchairFriendly,
                                    startTime: startTime)

        if !checkRestaurantQueue(for: newRecord) {
            return false
        }

        queueStorage.addQueueRecord(newRecord: newRecord) {
            self.queueDelegate?.didAddRecord()
        }
        return true
    }

    private func checkRestaurantQueue(for record: QueueRecord) -> Bool {
        if !record.restaurant.isQueueOpen {
            os_log("Queue is closed", log: Log.closeQueue, type: .info)
            queueDelegate?.didFindRestaurantQueueClosed()
            return false
        }

        os_log("Queue is open", log: Log.openQueue, type: .info)
        
        return true
    }

    func editQueueRecord(oldRecord: QueueRecord,
                         with groupSize: Int,
                         babyChairQuantity: Int,
                         wheelchairFriendly: Bool) {
        guard currentQueueRecords.contains(oldRecord) else {
            // not even current; cannot edit
            return
        }

        let newRecord = QueueRecord(id: oldRecord.id,
                                    restaurant: oldRecord.restaurant,
                                    customer: customer,
                                    groupSize: groupSize,
                                    babyChairQuantity: babyChairQuantity,
                                    wheelchairFriendly: wheelchairFriendly,
                                    startTime: oldRecord.startTime)

        queueStorage.updateQueueRecord(oldRecord: oldRecord, newRecord: newRecord) {
            self.queueDelegate?.didUpdateRecord()
        }
    }

    func withdrawQueueRecord(_ queueRecord: QueueRecord) {
        withdrawQueueRecord(queueRecord) {
            self.activitiesDelegate?.didWithdrawRecord()
        }
    }
    
    private func withdrawQueueRecord(_ queueRecord: QueueRecord, completion: @escaping () -> Void) {
        var newRecord = queueRecord
        newRecord.withdrawTime = Date()
        queueStorage.updateQueueRecord(oldRecord: queueRecord, newRecord: newRecord, completion: completion)
    }

    func confirmAdmissionOfQueueRecord(_ queueRecord: QueueRecord) {
        var newRecord = queueRecord
        let now = Date()
        newRecord.confirmAdmissionTime = now
        queueStorage.updateQueueRecord(oldRecord: queueRecord, newRecord: newRecord) {
            self.activitiesDelegate?.didConfirmAdmissionOfRecord()
        }
        for clashingRecords in currentQueueRecords
            where clashingRecords != queueRecord
                && clashingRecords.startTime <= now {
            withdrawQueueRecord(clashingRecords) {
                os_log("Confirmation triggered auto withdrawal of a qRec.",
                       log: Log.confirmedByCustomer, type: .info)
            }
        }
    }

    func didUpdateQueueRecord(_ record: QueueRecord) {
        os_log("Did update queue record", log: Log.updateQueueRecord, type: .info)
        guard let oldRecord = currentQueueRecords.first(where: { $0 == record }) else {
            os_log("Detected new queue record", log: Log.newQueueRecord, type: .info)
            didAddQueueRecord(record)
            return
        }
        let modification = record.changeType(from: oldRecord)
        switch modification {
        case .admit:
            didAdmitQueueRecord(record)
            os_log("Detected admission", log: Log.admitCustomer, type: .info)
        case .serve:
            didServeQueueRecord(record)
            os_log("Detected service", log: Log.serveCustomer, type: .info)
        case .reject:
            addAsHistoryRecord(record)
            removeFromCurrent(record)
            os_log("Detected rejection", log: Log.rejectCustomer, type: .info)
        case .withdraw:
            addAsHistoryRecord(record)
            removeFromCurrent(record)
            os_log("Detected withdrawal", log: Log.withdrawnByCustomer, type: .info)
        case .customerUpdate:
            customerDidUpdateQueueRecord(record: record)
            os_log("Detected regular modification", log: Log.regularModification, type: .info)
        case .confirmAdmission:
            didConfirmAdmissionOfQueueRecord(record)
        case .none:
            assert(false, "Modification should be something")
        }
    }

    private func didAddQueueRecord(_ record: QueueRecord) {
        if record.isActiveRecord && customerActivity.currentQueues.add(record) {
            activitiesDelegate?.didUpdateActiveRecords()
        }
        if record.isHistoryRecord && customerActivity.queueHistory.add(record) {
            activitiesDelegate?.didUpdateHistoryRecords()
        }
    }

    private func didConfirmAdmissionOfQueueRecord(_ record: QueueRecord) {
        // TODO: ?
        customerDidUpdateQueueRecord(record: record)
    }

    private func didAdmitQueueRecord(_ record: QueueRecord) {
        // tent
        customerDidUpdateQueueRecord(record: record)
    }

    private func didServeQueueRecord(_ record: QueueRecord) {
        // TODO: auto withdraw all other active queues (in case of late sync,
        // withdraw those whose starttime <= record.servetime

        addAsHistoryRecord(record)
        removeFromCurrent(record)
    }

    private func customerDidUpdateQueueRecord(record: QueueRecord) {
        if record.isActiveRecord {
            customerActivity.currentQueues.update(record)
            activitiesDelegate?.didUpdateActiveRecords()
            //queueDelegate?.didUpdateRecord()
        }
    }

    private func removeFromCurrent(_ record: QueueRecord) {
        if customerActivity.currentQueues.remove(record) {
            activitiesDelegate?.didUpdateActiveRecords()
        }
    }

    private func addAsHistoryRecord(_ record: QueueRecord) {
        if customerActivity.queueHistory.add(record) {
            activitiesDelegate?.didUpdateHistoryRecords()
        }
    }
}

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
    var queueRecords: [QueueRecord] {
        customerActivity.queueRecords
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
    }

    deinit {
        os_log("DEINITING queue logic manager", log: Log.deinitLogic, type: .info)
        queueStorage.unregisterDelegate(self)
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

    func enqueue(to restaurants: [Restaurant],
                 with groupSize: Int,
                 babyChairQuantity: Int,
                 wheelchairFriendly: Bool) -> Bool {
        guard !restaurants.isEmpty else {
            return true
        }

        guard restaurants.allSatisfy({ $0.isQueueOpen }) else {
            return false
        }

        let startTime = Date()
        let newRecords: [QueueRecord] = restaurants.map { restaurant in
            let newRecord = QueueRecord(restaurant: restaurant,
                                        customer: self.customer,
                                        groupSize: groupSize,
                                        babyChairQuantity: babyChairQuantity,
                                        wheelchairFriendly: wheelchairFriendly,
                                        startTime: startTime)

            return newRecord
        }

        queueStorage.addQueueRecords(newRecords: newRecords) {
            self.queueDelegate?.didAddRecords(newRecords)
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
        queueStorage.updateQueueRecord(oldRecord: queueRecord, newRecord: newRecord,
                                       completion: completion)
    }

    private func withdrawQueueRecords(_ queueRecords: [QueueRecord], completion: @escaping () -> Void) {
        guard !queueRecords.isEmpty else {
            completion()
            return
        }
        let withdrawTime = Date()
        var newRecords = [QueueRecord]()
        for record in queueRecords {
            var newRecord = record
            newRecord.withdrawTime = withdrawTime
            newRecords.append(newRecord)
        }
        queueStorage.updateQueueRecords(newRecords: newRecords, completion: completion)
    }

    func confirmAdmissionOfQueueRecord(_ record: QueueRecord) {
        confirmAdmissionOfQueueRecord(record, completion: {
            self.activitiesDelegate?.didConfirmAdmissionOfRecord()
        })
    }

    private func confirmAdmissionOfQueueRecord(_ queueRecord: QueueRecord, completion: @escaping () -> Void) {
        var newRecord = queueRecord
        newRecord.confirmAdmissionTime = Date()
        queueStorage.updateQueueRecord(oldRecord: queueRecord, newRecord: newRecord) {
            self.withdrawQueueRecords(self.clashingRecords(with: queueRecord), completion: completion)
        }

    }

    private func clashingRecords(with record: QueueRecord) -> [QueueRecord] {
        currentQueueRecords.filter { $0 != record && ($0.isPendingAdmission || $0.isAdmitted) }
    }

    func didUpdateQueueRecord(_ record: QueueRecord) {
        guard let oldRecord = queueRecords.first(where: { $0 == record }) else {
            return
        }

        let modification = record.changeType(from: oldRecord)
        switch modification {
        case .admit:
            didAdmitQueueRecord(record)
        case .serve:
            didServeQueueRecord(record)
        case .reject:
            didRejectQueueRecord(record)
        case .withdraw:
            didWithdrawQueuerecord(record)
        case .customerUpdate:
            customerDidUpdateQueueRecord(record: record)
        case .confirmAdmission:
            didConfirmAdmissionOfQueueRecord(record)
        default:
            assert(false, "Modification should be something")
        }
    }

    func didAddQueueRecord(_ record: QueueRecord) {
        os_log("Detected new queue record", log: Log.newQueueRecord, type: .info)
        if record.isActiveRecord && customerActivity.currentQueues.add(record) {
            activitiesDelegate?.didUpdateActiveRecords()
        }
        if record.isHistoryRecord && customerActivity.queueHistory.add(record) {
            activitiesDelegate?.didUpdateHistoryRecords()
        }
    }

    private func customerDidUpdateQueueRecord(record: QueueRecord) {
        os_log("Detected regular modification", log: Log.regularModification, type: .info)
        if record.isActiveRecord && customerActivity.currentQueues.update(record) {
            activitiesDelegate?.didUpdateActiveRecords()
        }
    }

    private func didAdmitQueueRecord(_ record: QueueRecord) {
        os_log("Detected admission", log: Log.admitCustomer, type: .info)
        guard customerActivity.currentQueues.update(record) else {
            return
        }
        activitiesDelegate?.didUpdateActiveRecords()

        // tent
        if clashingRecords(with: record).isEmpty {
            // auto accept since this is the only active queue
            confirmAdmissionOfQueueRecord(record, completion: {})
            return
        }
    }

    private func didConfirmAdmissionOfQueueRecord(_ record: QueueRecord) {
        // TODO: ?
        os_log("Detected confirmation", log: Log.confirmedByCustomer, type: .info)
        if customerActivity.currentQueues.update(record) {
            activitiesDelegate?.didUpdateActiveRecords()
        }
    }

    private func didWithdrawQueuerecord(_ record: QueueRecord) {
        os_log("Detected withdrawal", log: Log.withdrawnByCustomer, type: .info)
        addAsHistoryRecord(record)
        removeFromCurrent(record)
    }

    private func didServeQueueRecord(_ record: QueueRecord) {
        os_log("Detected service", log: Log.serveCustomer, type: .info)
        // TODO: auto withdraw all other active queues (in case of late sync,
        // withdraw those whose starttime <= record.servetime

        addAsHistoryRecord(record)
        removeFromCurrent(record)
    }

    private func didRejectQueueRecord(_ record: QueueRecord) {
        os_log("Detected rejection", log: Log.rejectCustomer, type: .info)
        addAsHistoryRecord(record)
        removeFromCurrent(record)
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

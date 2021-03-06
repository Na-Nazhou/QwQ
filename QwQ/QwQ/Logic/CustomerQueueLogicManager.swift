import Foundation
import os.log

/// A customer queue logic manager.
/// Customers are not allowed to queue for the same restaurant more than once at any time.
class CustomerQueueLogicManager: CustomerRecordLogicManager<QueueRecord>, CustomerQueueLogic {

    // Storage
    private var queueStorage: CustomerQueueStorage

    // Notification
    private var notificationHandler: QwQNotificationHandler

    // View Controller
    weak var queueDelegate: QueueDelegate?
    weak var searchDelegate: SearchDelegate?

    // Models
    private let customerActivity: CustomerActivity
    private var customer: Customer {
        customerActivity.customer
    }
    private var currentQueues: RecordCollection<QueueRecord> {
        customerActivity.currentQueues
    }
    private var missedQueues: RecordCollection<QueueRecord> {
        customerActivity.missedQueues
    }
    private var queueHistory: RecordCollection<QueueRecord> {
        customerActivity.queueHistory
    }

    private var currentQueueRecords: [QueueRecord] {
        customerActivity.currentQueues.records + customerActivity.missedQueues.records
    }
    private var queueRecords: [QueueRecord] {
        customerActivity.queueRecords
    }

    override convenience init() {
        self.init(customerActivity: CustomerActivity.shared(),
                  queueStorage: FIRQueueStorage.shared,
                  notificationHandler: QwQNotificationManager.shared)
    }

    // Constructor to provide flexibility for testing.
    init(customerActivity: CustomerActivity, queueStorage: CustomerQueueStorage,
         notificationHandler: QwQNotificationHandler) {
        self.customerActivity = customerActivity
        self.queueStorage = queueStorage
        self.notificationHandler = notificationHandler

        super.init()

        self.queueStorage.registerDelegate(self)
    }

    deinit {
        os_log("Deiniting queue logic manager", log: Log.deinitLogic, type: .info)
        queueStorage.unregisterDelegate(self)
    }

    func canQueue(for restaurant: Restaurant) -> Bool {
        restaurant.isQueueOpen
            && currentQueueRecords.allSatisfy { $0.restaurant != restaurant }
    }

    func enqueue(to restaurants: [Restaurant],
                 with groupSize: Int,
                 babyChairQuantity: Int,
                 wheelchairFriendly: Bool) -> Bool {
        guard !restaurants.isEmpty else {
            return true
        }

        if let restaurant = restaurants.first(where: { !$0.isQueueOpen }) {
            queueDelegate?.didFindRestaurantQueueClosed(for: restaurant)
            return false
        }

        let startTime = Date()
        let newRecords: [QueueRecord] = restaurants.map { restaurant in
            QueueRecord(restaurant: restaurant,
                        customer: customer,
                        groupSize: groupSize,
                        babyChairQuantity: babyChairQuantity,
                        wheelchairFriendly: wheelchairFriendly,
                        startTime: startTime)
        }

        queueStorage.addQueueRecords(newRecords: newRecords) {
            self.queueDelegate?.didAddRecords(newRecords)
        }
        return true
    }

    private func checkRestaurantQueue(for record: QueueRecord) -> Bool {
        if !record.restaurant.isQueueOpen {
            os_log("Queue is closed", log: Log.closeQueue, type: .info)
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

    func withdrawQueueRecord(_ record: QueueRecord) {
        withdrawQueueRecord(record) {
            self.activitiesDelegate?.didWithdrawRecord()
        }
    }
    
    private func withdrawQueueRecord(_ record: QueueRecord, completion: @escaping () -> Void) {
        let newRecord = getUpdatedRecord(record: record, event: .withdraw)
        queueStorage.updateQueueRecord(oldRecord: record, newRecord: newRecord, completion: completion)
    }

    private func withdrawQueueRecords(_ records: [QueueRecord], completion: @escaping () -> Void) {
        guard !records.isEmpty else {
            completion()
            return
        }
        let newRecords = records.map {
            getUpdatedRecord(record: $0, event: .withdraw)
        }
        queueStorage.updateQueueRecords(newRecords: newRecords, completion: completion)
    }

    func confirmAdmissionOfQueueRecord(_ record: QueueRecord) {
        confirmAdmission(of: record, completion: {
            self.activitiesDelegate?.didConfirmAdmissionOfRecord()
        })
    }

    private func confirmAdmission(of record: QueueRecord,
                                  completion: @escaping () -> Void) {
        var newRecord = record
        newRecord.confirmAdmissionTime = Date()
        queueStorage.updateQueueRecord(oldRecord: record, newRecord: newRecord) {
            self.withdrawQueueRecords(self.clashingRecords(with: record), completion: completion)
        }
    }

    private func clashingRecords(with record: QueueRecord) -> [QueueRecord] {
        currentQueueRecords.filter { $0 != record && ($0.isPendingAdmission || $0.isAdmitted || $0.isMissedAndPending) }
    }

    override func removeRecord(_ record: QueueRecord, from collection: RecordCollection<QueueRecord>) {
        super.removeRecord(record, from: collection)
        searchDelegate?.didUpdateQueueRecordCollection()
    }
}

extension CustomerQueueLogicManager {

    // MARK: Syncing
    /// Detects modification to `record` and updates in-app models accordingly.
    func didUpdateQueueRecord(_ record: QueueRecord) {
        guard let oldRecord = queueRecords.first(where: { $0 == record }) else {
            return
        }

        let modification = record.getChangeType(from: oldRecord)
        switch modification {
        case .miss:
            didMissQueueRecord(record)
        case .admit, .readmit:
            didAdmitQueueRecord(record)
        case .serve:
            didServeQueueRecord(record)
        case .reject:
            didRejectQueueRecord(record)
        case .withdraw:
            didWithdrawQueueRecord(record)
        case .customerUpdate:
            customerDidUpdateQueueRecord(record)
        case .confirmAdmission:
            didConfirmAdmission(of: record)
        default:
            customerDidUpdateQueueRecord(record)
        }
    }

    func didAddQueueRecord(_ record: QueueRecord) {
        os_log("Detected new queue record", log: Log.newQueueRecord, type: .info)
        if record.status == .missedAndPending {
            super.didAddRecord(record, currentQueues, missedQueues, queueHistory)
        }
        super.didAddRecord(record, currentQueues, missedQueues, queueHistory)
    
        searchDelegate?.didUpdateQueueRecordCollection()
    }

    private func customerDidUpdateQueueRecord(_ record: QueueRecord) {
        super.customerDidUpdateRecord(record, currentQueues, missedQueues, queueHistory)
    }

    private func didAdmitQueueRecord(_ record: QueueRecord) {
        os_log("Detected admission", log: Log.admitCustomer, type: .info)
        if record.wasOnceMissed {
            super.removeRecord(record, from: missedQueues)
            super.addRecord(record, to: currentQueues)
        } else {
            super.updateRecord(record, in: currentQueues)
        }

        if clashingRecords(with: record).isEmpty {
            confirmAdmission(of: record, completion: {})
            return
        }
        notificationHandler.notifyQueueAdmittedAwaitingConfirmation(record: record)
    }

    private func didMissQueueRecord(_ record: QueueRecord) {
        os_log("Detected miss", log: Log.missCustomer, type: .info)
        addRecord(record, to: missedQueues)
        removeRecord(record, from: currentQueues)

        notificationHandler.notifyQueueMissed(record: record)
    }

    private func didConfirmAdmission(of record: QueueRecord) {
        super.didConfirmRecord(record, currentQueues)

        notificationHandler.retractQueueNotifications(for: record)
        notificationHandler.notifyQueueConfirmed(record: record)
    }

    private func didServeQueueRecord(_ record: QueueRecord) {
        super.didServeRecord(record, currentQueues, queueHistory)

        notificationHandler.retractQueueNotifications(for: record)
    }

    private func didRejectQueueRecord(_ record: QueueRecord) {
        super.didRejectRecord(record, currentQueues, queueHistory)
        super.didRejectRecord(record, missedQueues, queueHistory)

        notificationHandler.retractQueueNotifications(for: record)
        notificationHandler.notifyQueueRejected(record: record)
    }

    private func didWithdrawQueueRecord(_ record: QueueRecord) {
        super.didWithdrawRecord(record, currentQueues, queueHistory)
        super.didWithdrawRecord(record, missedQueues, queueHistory)

        notificationHandler.retractQueueNotifications(for: record)
    }
}

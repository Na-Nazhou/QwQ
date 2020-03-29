import Foundation
import os.log

class CustomerQueueLogicManager: CustomerQueueLogic {

    // Storage
    var queueStorage: CustomerQueueStorage

    // View Controller
    weak var queueDelegate: QueueDelegate?
    weak var activitiesDelegate: ActivitiesDelegate?

    var customer: Customer
    var currentQueueRecord: QueueRecord? {
        didSet {
            if let rec = currentQueueRecord {
                activitiesDelegate?.didUpdateActiveRecords()

                if let old = oldValue, old == rec {
                    return
                }

                os_log("qlogic adding listener", log: Log.qLogicAddListener, type: .info)
                queueStorage.registerListener(for: rec)
            }
        }
    }

    private var queueHistory = RecordCollection<QueueRecord>()
    var pastQueueRecords: [QueueRecord] {
        queueHistory.records
    }

    private init(customer: Customer, queueStorage: CustomerQueueStorage) {
        self.customer = customer
        self.queueStorage = queueStorage

        loadQueueRecord()
        fetchQueueHistory()
    }

    deinit {
        os_log("DEINITING", log: Log.deinitLogic, type: .info)
        if let record = currentQueueRecord {
            queueStorage.removeListener(for: record)
        }
    }

    private func loadQueueRecord() {
        queueStorage.loadActiveQueueRecords(customer: customer, completion: {
            guard let queueRecord = $0 else {
                return
            }
            self.currentQueueRecord = queueRecord
        })
    }

    func fetchQueueHistory() {
        queueStorage.loadQueueHistory(customer: customer, completion: {
            guard $0 != nil else {
                return
            }
            let didAddNew = self.queueHistory.add($0!)
            if !didAddNew {
                return
            }
            self.activitiesDelegate?.didUpdateHistoryRecords()
        })
    }

    func canQueue(for restaurant: Restaurant) -> Bool {
        restaurant.isQueueOpen && currentQueueRecord == nil
    }

    func enqueue(to restaurant: Restaurant,
                 with groupSize: Int,
                 babyChairQuantity: Int,
                 wheelchairFriendly: Bool) -> Bool {
        guard currentQueueRecord == nil else {
            return false
        }

        let startTime = Date()
        var newRecord = QueueRecord(restaurant: restaurant,
                                    customer: customer,
                                    groupSize: groupSize,
                                    babyChairQuantity: babyChairQuantity,
                                    wheelchairFriendly: wheelchairFriendly,
                                    startTime: startTime)

        if !checkRestaurantQueue(for: newRecord) {
            return false
        }

        queueStorage.addQueueRecord(newRecord: newRecord,
                                    completion: { self.didAddQueueRecord(newRecord: &newRecord, id: $0)

        })
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

    private func didAddQueueRecord(newRecord: inout QueueRecord, id: String) {
        newRecord.id = id
        currentQueueRecord = newRecord

        queueDelegate?.didAddRecord()
    }

    func editQueueRecord(oldRecord: QueueRecord,
                         with groupSize: Int,
                         babyChairQuantity: Int,
                         wheelchairFriendly: Bool) {
        guard oldRecord == currentQueueRecord else {
            // Check if there is any change
            // Check the queue record is not admitted yet
            return
        }
        // Cannot update the restaurant, startTime, etc
        // Reset startTime (??)

        let newRecord = QueueRecord(id: oldRecord.id,
                                    restaurant: oldRecord.restaurant,
                                    customer: customer,
                                    groupSize: groupSize,
                                    babyChairQuantity: babyChairQuantity,
                                    wheelchairFriendly: wheelchairFriendly,
                                    startTime: oldRecord.startTime)

        queueStorage.updateQueueRecord(oldRecord: oldRecord, newRecord: newRecord, completion: {
            self.queueDelegate?.didUpdateRecord()
        })
    }

    func deleteQueueRecord(_ queueRecord: QueueRecord) {
        guard let record = currentQueueRecord,
            queueRecord == record else {
            return
        }

        if queueRecord.isAdmitted {
            var newRecord = queueRecord
            newRecord.withdrawTime = Date()
            queueStorage.updateQueueRecord(oldRecord: queueRecord, newRecord: newRecord, completion: {
                self.activitiesDelegate?.didDeleteRecord()
            })
            return
        }

        queueStorage.deleteQueueRecord(record: record, completion: {
            self.activitiesDelegate?.didDeleteRecord()
        })
    }

    func didUpdateQueueRecord(_ record: QueueRecord) {
        assert(currentQueueRecord != nil, "current queue record should exist to trigger udpate.")
        assert(currentQueueRecord! == record, "Should only receive update for current queue record.")
        let modification = record.changeType(from: currentQueueRecord!)
        os_log("Did update queue record", log: Log.updateQueueRecord, type: .info)
        switch modification {
        case .admit:
            // call some (activites) delegate to display admission status
            currentQueueRecord = record //tent.
            os_log("Detected admission", log: Log.admitCustomer, type: .info)
        case .serve:
            addAsHistoryRecord(record)
            didDeleteQueueRecord(record)
            os_log("Detected service", log: Log.serveCustomer, type: .info)
        case .reject:
            addAsHistoryRecord(record)
            didDeleteQueueRecord(record)
            os_log("Detected rejection", log: Log.rejectCustomer, type: .info)
        case .withdraw:
            addAsHistoryRecord(record)
            didDeleteQueueRecord(record)
            os_log("Detected withdrawal", log: Log.withdrawnByCustomer, type: .info)
        case .customerUpdate:
            customerDidUpdateQueueRecord(record: record)
            os_log("Detected regular modification", log: Log.regularModification, type: .info)
        case .none:
            assert(false, "Modification should be something")
        }
    }

    private func customerDidUpdateQueueRecord(record: QueueRecord) {
        currentQueueRecord = record
    }

    func didDeleteQueueRecord(_ record: QueueRecord) {
        assert(currentQueueRecord == record)

        queueStorage.removeListener(for: record)
        currentQueueRecord = nil
        activitiesDelegate?.didUpdateActiveRecords()
    }

    private func addAsHistoryRecord(_ record: QueueRecord) {
        if queueHistory.add(record) {
            activitiesDelegate?.didUpdateHistoryRecords()
        }
    }
}

extension CustomerQueueLogicManager {
    private static var queueLogic: CustomerQueueLogicManager?

    /// Returns shared customer queue logic manager for the logged in application. If it does not exist,
    /// a queue logic manager is initiailised with the given customer identity to share.
    static func shared(for customerIdentity: Customer? = nil,
                       with storage: CustomerQueueStorage? = nil) -> CustomerQueueLogicManager {
        if let logic = queueLogic {
            return logic
        }

        assert(customerIdentity != nil,
               "Customer identity must be given non-nil to make the customer's queue logic manager.")
        assert(storage != nil, "Queue storage must be given non-nil")
        let logic = CustomerQueueLogicManager(customer: customerIdentity!, queueStorage: storage!)
        logic.queueStorage.logicDelegate = logic

        queueLogic = logic
        return logic
    }

    static func deinitShared() {
        queueLogic = nil
    }
}

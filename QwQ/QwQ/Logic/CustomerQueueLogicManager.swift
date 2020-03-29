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
                  queueStorage: FBQueueStorage.shared)
    }

    // Constructor to provide flexibility for testing.
    init(customerActivity: CustomerActivity, queueStorage: CustomerQueueStorage) {
        self.customerActivity = customerActivity
        self.queueStorage = queueStorage

        self.queueStorage.registerDelegate(self)

        loadActiveQueueRecords()
        fetchQueueHistory()
    }

    deinit {
        os_log("DEINITING", log: Log.deinitLogic, type: .info)
        for record in currentQueueRecords {
            queueStorage.removeListener(for: record)
        }
        queueStorage.unregisterDelegate(self)
    }

    private func loadActiveQueueRecords() {
        print("\tfetching active qrecs")
        if !currentQueueRecords.isEmpty {
            print("\tbut realised already loaded?")
            return //already loaded, no need to reload.
        }
        print("\tso loading.")
        queueStorage.loadActiveQueueRecords(customer: customer, completion: {
            guard let queueRecord = $0 else {
                return
            }
            if self.customerActivity.currentQueues.add(queueRecord) {
                self.activitiesDelegate?.didUpdateActiveRecords()
                self.queueStorage.registerListener(for: queueRecord)
                print("registed listener for loaded active qrec \(queueRecord.id)")
            }
        })
    }

    func fetchQueueHistory() {
        if !pastQueueRecords.isEmpty {
            return
        }
        queueStorage.loadQueueHistory(customer: customer, completion: {
            guard $0 != nil else {
                return
            }
            if self.customerActivity.queueHistory.add($0!) {
                self.activitiesDelegate?.didUpdateHistoryRecords()
            }
        })
    }

    func canQueue(for restaurant: Restaurant) -> Bool {
        // add any other queueing restrictions here
        restaurant.isQueueOpen
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

        queueStorage.addQueueRecord(newRecord: newRecord,
                                    completion: {
                                        self.didAddQueueRecord(newRecord: newRecord, withUpdatedId: $0)

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

    private func didAddQueueRecord(newRecord: QueueRecord, withUpdatedId id: String) {
        var updatedIdRec = newRecord
        updatedIdRec.id = id
        print("in did ad qrec")
        guard customerActivity.currentQueues.add(updatedIdRec) else {
            print("but alr added?")
            assert(updatedIdRec.id == customerActivity.currentQueues.getOriginalElement(of: updatedIdRec).id,
                   "Added queue record should already have legit id.")
            return
        }
        print("adding listener for added qrec")
        self.queueStorage.registerListener(for: updatedIdRec)
        queueDelegate?.didAddRecord()
        activitiesDelegate?.didUpdateActiveRecords()
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

        queueStorage.updateQueueRecord(oldRecord: oldRecord, newRecord: newRecord, completion: {
            self.queueDelegate?.didUpdateRecord()
        })
    }

    func deleteQueueRecord(_ queueRecord: QueueRecord) {
        guard currentQueueRecords.contains(queueRecord) else {
            return
        }

        var newRecord = queueRecord
        newRecord.withdrawTime = Date()
        queueStorage.updateQueueRecord(oldRecord: queueRecord, newRecord: newRecord, completion: {
            self.activitiesDelegate?.didDeleteRecord()
        })
        // we dont allow true deletion of any info from db.
    }

    func didUpdateQueueRecord(_ record: QueueRecord) {
        assert(currentQueueRecords.contains(record),
               "Record in which update is detected should be an existing current queue record. "
        + "Perhaps customer did not listen to newly added queue record.")
        let modification = record.changeType(from: customerActivity.currentQueues.getOriginalElement(of: record))
        os_log("Did update queue record", log: Log.updateQueueRecord, type: .info)
        switch modification {
        case .admit:
            // call some (activites) delegate to display admission status
            customerDidUpdateQueueRecord(record: record) //tent.
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
        if record.isActiveRecord {
            customerActivity.currentQueues.update(record)
            activitiesDelegate?.didUpdateActiveRecords()
        }
    }

    func didDeleteQueueRecord(_ record: QueueRecord) {
        removeFromCurrent(record)
    }

    private func removeFromCurrent(_ record: QueueRecord) {
        queueStorage.removeListener(for: record)
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

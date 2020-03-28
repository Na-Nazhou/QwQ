import Foundation

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

        loadQueueRecord()
        fetchQueueHistory()
    }

    deinit {
        for record in customerActivity.currentQueues.records {
            queueStorage.removeListener(for: record)
        }
        queueStorage.unregisterDelegate(self)
    }

    private func loadQueueRecord() {
        queueStorage.loadActiveQueueRecords(customer: customer, completion: {
            guard let queueRecord = $0 else {
                return
            }
            if self.customerActivity.currentQueues.add(queueRecord) {
                self.activitiesDelegate?.didUpdateActiveRecords()
                self.queueStorage.registerListener(for: queueRecord)
            }
        })
    }

    func fetchQueueHistory() {
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
                                    completion: { self.didAddQueueRecord(newRecord: newRecord, withUpdatedId: $0)

        })
        return true
    }

    private func checkRestaurantQueue(for record: QueueRecord) -> Bool {
        if !record.restaurant.isQueueOpen {
            print("Queue closed")
            queueDelegate?.didFindRestaurantQueueClosed()
            return false
        }

        return true
    }

    private func didAddQueueRecord(newRecord: QueueRecord, withUpdatedId id: String) {
        var updatedIdRec = newRecord
        updatedIdRec.id = id
        guard customerActivity.currentQueues.add(updatedIdRec) else {
            assert(updatedIdRec.id == customerActivity.currentQueues.getOriginalElement(of: updatedIdRec).id,
                   "Added queue record should already have legit id.")
            return
        }
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
        switch modification {
        case .admit:
            // call some (activites) delegate to display admission status
            customerActivity.currentQueues.update(record) //tent.
            print("\ndetected admission\n")
        case .serve:
            addAsHistoryRecord(record)
            removeFromCurrent(record)
            print("\ndetected service\n")
        case .reject:
            addAsHistoryRecord(record)
            removeFromCurrent(record)
            print("\ndetected rejection\n")
        case .withdraw:
            addAsHistoryRecord(record)
            removeFromCurrent(record)
        case .customerUpdate:
            customerDidUpdateQueueRecord(record: record)
            print("\ndetected regular modif\n")
        case .none:
            assert(false, "Modification should be something")
        }
    }

    private func customerDidUpdateQueueRecord(record: QueueRecord) {
        customerActivity.currentQueues.update(record)
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

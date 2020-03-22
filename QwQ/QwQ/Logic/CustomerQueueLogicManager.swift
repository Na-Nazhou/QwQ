import Foundation

class CustomerQueueLogicManager: CustomerQueueLogic {

    // Storage
    var queueStorage: CustomerQueueStorage

    // View Controller
    weak var queueDelegate: QueueDelegate?
    weak var activitiesDelegate: ActivitiesDelegate?

    var customer: Customer
    var currentQueueRecord: QueueRecord?

    private var queueHistory = CustomerQueueHistory()
    var pastQueueRecords: [QueueRecord] {
        Array(queueHistory.history)
    }

    private init(customer: Customer) {
        self.customer = customer
        queueStorage = FBQueueStorage()
        loadQueueRecord()
        fetchQueueHistory()
    }

    deinit {
        print("\n\tDEINITING\n")
        queueStorage.removeListener()
    }

    private func loadQueueRecord() {
        queueStorage.loadQueueRecord(customer: customer, completion: {
            guard let queueRecord = $0 else {
                return
            }
            self.currentQueueRecord = queueRecord
            self.queueStorage.listenOnlyToCurrentRecord(queueRecord)
        })
    }

    func canQueue(for restaurant: Restaurant) -> Bool {
        restaurant.isQueueOpen && currentQueueRecord == nil
    }

    func fetchQueueHistory() {
        queueStorage.loadQueueHistory(customer: customer, completion: {
            guard $0 != nil else {
                return
            }
            let didAddNew = self.queueHistory.addToHistory($0!)
            if !didAddNew {
                return
            }
            self.activitiesDelegate?.didLoadNewHistoryRecords()
        })
    }

    func enqueue(to restaurant: Restaurant,
                 with groupSize: Int,
                 babyChairQuantity: Int,
                 wheelchairFriendly: Bool) {
        guard canQueue(for: restaurant) else {
            return
        }

        let startTime = Date()
        var newRecord = QueueRecord(restaurant: restaurant,
                                    customer: customer,
                                    groupSize: groupSize,
                                    babyChairQuantity: babyChairQuantity,
                                    wheelchairFriendly: wheelchairFriendly,
                                    startTime: startTime)

        queueStorage.addQueueRecord(newRecord: newRecord,
                                    completion: { self.didAddQueueRecord(newRecord: &newRecord, id: $0)

        })
    }

    private func didAddQueueRecord(newRecord: inout QueueRecord, id: String) {
        newRecord.id = id
        currentQueueRecord = newRecord

        queueStorage.listenOnlyToCurrentRecord(newRecord)
        queueDelegate?.didAddQueueRecord()
    }

    func editQueueRecord(with groupSize: Int,
                         babyChairQuantity: Int,
                         wheelchairFriendly: Bool) {
        guard let oldRecord = currentQueueRecord else {
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
            self.queueDelegate?.didUpdateQueueRecord()
        })
    }

    private func customerDidUpdateQueueRecord(record: QueueRecord) {
        currentQueueRecord = record
        activitiesDelegate?.didUpdateQueueRecord()
    }

    func deleteQueueRecord(_ queueRecord: QueueRecord) {
        guard let record = currentQueueRecord,
            queueRecord.id == record.id else {
            return
        }

        queueStorage.deleteQueueRecord(record: record, completion: {
            self.activitiesDelegate?.didDeleteQueueRecord()
        })
    }

    func didUpdateQueueRecord(_ record: QueueRecord) {
        assert(currentQueueRecord != nil, "current queue record should exist to trigger udpate.")
        assert(currentQueueRecord! == record, "Should only receive update for current queue record.")
        let modification = record.changeType(from: currentQueueRecord!)
        switch modification {
        case .admit:
            // call some (activites) delegate to display admission status
            currentQueueRecord = record //tent.
            print("\ndetected admission\n")
        case .serve:
            addAsHistoryRecord(record)
            didDeleteActiveQueueRecord()
            print("\ndetected service\n")
        case .reject:
            addAsHistoryRecord(record)
            didDeleteActiveQueueRecord()
            print("\ndetected rejection\n")
        case .customerUpdate:
            customerDidUpdateQueueRecord(record: record)
            print("\ndetected regular modif\n")
        case .none:
            assert(false, "Modification should be something")
        }
    }

    func didDeleteActiveQueueRecord() {
        assert(currentQueueRecord != nil, "There should exist an active queue record to remove.")
        queueStorage.removeListener()
        currentQueueRecord = nil
    }

    private func addAsHistoryRecord(_ record: QueueRecord) {
        if queueHistory.addToHistory(record) {
            activitiesDelegate?.didLoadNewHistoryRecords()
        }
    }
}

extension CustomerQueueLogicManager {
    private static var queueLogic: CustomerQueueLogicManager?

    /// Returns shared customer queue logic manager for the logged in application. If it does not exist,
    /// a queue logic manager is initiailised with the given customer identity to share.
    static func shared(for customerIdentity: Customer? = nil) -> CustomerQueueLogicManager {
        if let logic = queueLogic {
            return logic
        }

        assert(customerIdentity != nil,
               "Customer identity must be given non-nil to make the customer's queue logic manager.")
        let logic = CustomerQueueLogicManager(customer: customerIdentity!)
        logic.queueStorage.queueModificationLogicDelegate = logic

        queueLogic = logic
        return logic
    }

    static func deinitShared() {
        queueLogic = nil
    }
}

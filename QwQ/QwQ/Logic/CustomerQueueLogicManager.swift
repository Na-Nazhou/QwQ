import Foundation

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

                print("qlogic adding listener")
                queueStorage.registerListener(for: rec)
            }
        }
    }

    private var queueHistory = CustomerHistory<QueueRecord>()
    var pastQueueRecords: [QueueRecord] {
        Array(queueHistory.history)
    }

    private init(customer: Customer, queueStorage: CustomerQueueStorage) {
        self.customer = customer
        self.queueStorage = queueStorage
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
        })
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
            self.activitiesDelegate?.didUpdateHistoryRecords()
        })
    }

    func canQueue(for restaurant: Restaurant) -> Bool {
        restaurant.isQueueOpen && currentQueueRecord == nil
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

    func deleteQueueRecord(_ queueRecord: QueueRecord) {
        guard let record = currentQueueRecord,
            queueRecord == record else {
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
            didDeleteQueueRecord(record)
            print("\ndetected service\n")
        case .reject:
            addAsHistoryRecord(record)
            didDeleteQueueRecord(record)
            print("\ndetected rejection\n")
        case .customerUpdate:
            customerDidUpdateQueueRecord(record: record)
            print("\ndetected regular modif\n")
        case .none:
            assert(false, "Modification should be something")
        }
    }

    private func customerDidUpdateQueueRecord(record: QueueRecord) {
        currentQueueRecord = record
    }

    func didDeleteQueueRecord(_ record: QueueRecord) {
        assert(currentQueueRecord != nil, "There should exist an active queue record to remove.")
        queueStorage.removeListener()
        currentQueueRecord = nil
        activitiesDelegate?.didUpdateActiveRecords()
    }

    private func addAsHistoryRecord(_ record: QueueRecord) {
        if queueHistory.addToHistory(record) {
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
        logic.queueStorage.queueModificationLogicDelegate = logic

        queueLogic = logic
        return logic
    }

    static func deinitShared() {
        queueLogic = nil
    }
}

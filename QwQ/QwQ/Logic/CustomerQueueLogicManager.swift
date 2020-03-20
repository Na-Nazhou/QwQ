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
                activitiesDelegate?.didUpdateQueueRecord()

                if let old = oldValue, old == rec {
                    return
                }

                print("qlogic adding listener")
                queueStorage.listenOnlyToCurrentRecord(rec)
            }
        }
    }
    private var queueHistory = CustomerQueueHistory()
    var pastQueueRecords: [QueueRecord] {
        return Array(queueHistory.history)
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
            self.currentQueueRecord = $0
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
                                    startTime: startTime,
                                    admitTime: nil)

        queueStorage.addQueueRecord(record: newRecord,
                                    completion: { self.didAddQueueRecord(newRecord: &newRecord, id: $0)

        })
    }

    private func didAddQueueRecord(newRecord: inout QueueRecord, id: String) {
        newRecord.id = id
        self.currentQueueRecord = newRecord
        self.queueDelegate?.didAddQueueRecord()
    }

    func editQueueRecord(with groupSize: Int,
                         babyChairQuantity: Int,
                         wheelchairFriendly: Bool) {
        guard let old = currentQueueRecord else {
            // Check if there is any change
            // Check the queue record is not admitted yet
            return
        }
        // Cannot update the restaurant, startTime
        // Reset startTime (??)

        var new = QueueRecord(restaurant: old.restaurant,
                              customer: customer,
                              groupSize: groupSize,
                              babyChairQuantity: babyChairQuantity,
                              wheelchairFriendly: wheelchairFriendly,
                              startTime: old.startTime,
                              admitTime: nil)

        queueStorage.updateQueueRecord(old: old, new: new,
                                       completion: { self.didUpdateQueueRecord(old: old, new: &new) })
    }

    private func didUpdateQueueRecord(old: QueueRecord, new: inout QueueRecord) {
        new.id = old.id
        self.currentQueueRecord = new
        self.queueDelegate?.didUpdateQueueRecord()
    }

    func deleteQueueRecord(_ queueRecord: QueueRecord) {
        guard let record = currentQueueRecord,
            queueRecord.id == record.id else {
            return
        }

        queueStorage.deleteQueueRecord(record: record,
                                       completion: {  })
    }

    func queueRecordDidUpdate(_ record: QueueRecord) {
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
            removeActiveRecord()
            print("\ndetected service\n")
        case .reject:
            addAsHistoryRecord(record)
            removeActiveRecord()
            print("\ndetected rejection\n")
        case .customerUpdate:
            currentQueueRecord = record
            print("\ndetected regular modif\n")
        case .none:
            assert(false, "Modification should be something")
        }
    }

    func customerDidDeleteActiveQueueRecord() {
        assert(currentQueueRecord != nil, "There should exist an active queue record to remove.")
        removeActiveRecord()
    }

    private func removeActiveRecord() {
        queueStorage.removeListener()

        currentQueueRecord = nil
        activitiesDelegate?.didDeleteQueueRecord()
    }

    private func addAsHistoryRecord(_ record: QueueRecord) {
        if queueHistory.addToHistory(record) {
            activitiesDelegate?.didLoadNewHistoryRecords()
        }
    }

    func restaurantDidAdmitCustomer(record: QueueRecord) {
        guard currentQueueRecord != nil, record.customer == customer else {
            return
        }

        // Notify customer

        currentQueueRecord?.admitTime = record.admitTime
    }

    func restaurantDidRejectCustomer(record: QueueRecord) {
        guard currentQueueRecord != nil, record.customer == customer else {
            return
        }

        // Notify customer

        currentQueueRecord?.rejectTime = record.rejectTime
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

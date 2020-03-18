import Foundation

class CustomerQueueLogicManager: CustomerQueueLogic {

    // Storage
    var queueStorage: CustomerQueueStorage

    // View Controller
    weak var queueDelegate: QueueDelegate?
    weak var activitiesDelegate: ActivitiesDelegate?

    var customer: Customer
    var currentQueueRecord: QueueRecord?
    var queueHistory = CustomerQueueHistory() //[QueueRecord]()

    private init(customer: Customer) {
        self.customer = customer
        queueStorage = FBQueueStorage()
        loadQueueRecord()
    }

    private func loadQueueRecord() {
        queueStorage.loadQueueRecord(customer: customer, completion: {
            self.currentQueueRecord = $0
        })
    }

    func canQueue(for restaurant: Restaurant) -> Bool {
        restaurant.isOpen && currentQueueRecord == nil
    }

    func fetchQueueHistory() {
        queueStorage.loadQueueHistory(customer: customer, completion: {
            guard $0 != nil else {
                return
            }
            self.queueHistory.addToHistory($0!)
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
                                    completion: {
                                        newRecord.id = $0
                                        self.currentQueueRecord = newRecord
                                        self.queueDelegate?.didAddQueueRecord()
        })
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
                                       completion: {
                                        new.id = old.id
                                        self.currentQueueRecord = new
                                        self.queueDelegate?.didUpdateQueueRecord()
        })
    }

    func deleteQueueRecord() {
        guard let record = currentQueueRecord else {
            return
        }

        queueStorage.deleteQueueRecord(record: record,
                                       completion: {
                                        self.currentQueueRecord = nil
                                        self.activitiesDelegate?.didDeleteQueueRecord()
        })
    }

    func restaurantDidAdmitCustomer(record: QueueRecord) {
        guard currentQueueRecord != nil, record.customer == customer else {
            return
        }

        // Notify customer

        currentQueueRecord = nil
    }

    func restaurantDidRejectCustomer(record: QueueRecord) {
        guard currentQueueRecord != nil, record.customer == customer else {
            return
        }

        // Notify customer

        currentQueueRecord = nil
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

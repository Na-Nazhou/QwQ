import Foundation

class CustomerQueueLogicManager: CustomerQueueLogic {

    // Storage
    var queueStorage: CustomerQueueStorage

    // View Controller
    weak var queueDelegate: QueueDelegate?

    private(set) var customer: Customer
    var currentQueueRecord: QueueRecord?

    private init(customer: Customer) {
        self.customer = customer
        queueStorage = FBQueueStorage()
        loadQueueRecord()
    }

    private func loadQueueRecord() {
        currentQueueRecord = queueStorage.loadQueueRecord(customer: customer)
    }

    func enqueue(to restaurant: Restaurant,
                 with groupSize: Int,
                 babyChairQuantity: Int,
                 wheelchairFriendly: Bool) {
        guard currentQueueRecord == nil else {
            // Disallow enqueue if there is a current queue
            // Check if the restaurant is open
            // TODO
            return
        }

        let startTime = Date()
        let newRecord = QueueRecord(restaurant: restaurant,
                                    customer: customer,
                                    groupSize: groupSize,
                                    babyChairQuantity: babyChairQuantity,
                                    wheelchairFriendly: wheelchairFriendly,
                                    startTime: startTime,
                                    admitTime: nil,
                                    serveTime: nil)

        queueStorage.addQueueRecord(record: newRecord)
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

        let new = QueueRecord(restaurant: old.restaurant,
                              customer: customer,
                              groupSize: groupSize,
                              babyChairQuantity: babyChairQuantity,
                              wheelchairFriendly: wheelchairFriendly,
                              startTime: old.startTime,
                              admitTime: nil,
                              serveTime: nil)

        queueStorage.updateQueueRecord(old: old, new: new)
    }

    func deleteQueueRecord() {
        guard let record = currentQueueRecord else {
            return
        }

        queueStorage.deleteQueueRecord(record: record)
    }

    func restaurantDidServeCustomer(record: QueueRecord) {
        //
    }

    func restaurantDidAdmitCustomer(record: QueueRecord) {
        guard currentQueueRecord != nil, record.customer == customer else {
            return
        }

        currentQueueRecord = nil
    }

    func restaurantDidRejectCustomer(record: QueueRecord) {
        //
    }

    func customerDidJoinQueue(with record: QueueRecord) {
        guard record.customer == customer else {
            return
        }

        currentQueueRecord = record
    }

    func customerDidUpdateQueueRecord(from old: QueueRecord, to new: QueueRecord) {
        guard old.customer == customer && new.customer == customer else {
            return
        }

        currentQueueRecord = new
    }
    
    func customerDidWithdrawQueue(record: QueueRecord) {
        guard record.customer == customer else {
            return
        }

        currentQueueRecord = nil
    }

    // if we allow restaurants to reject customers
    func restaurantDidRemoveQueueRecord(record: QueueRecord) {
        //
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

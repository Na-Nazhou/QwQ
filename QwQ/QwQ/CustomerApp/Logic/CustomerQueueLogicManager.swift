import Foundation

class CustomerQueueLogicManager: CustomerQueueLogic {
    var queueStorage: CustomerQueueStorage = CustomerQueueStorageStub()

    private static var queueLogic: CustomerQueueLogicManager?

    /// Returns shared customer queue logic manager for the logged in application. If it does not exist,
    /// a queue logic manager is initiailised with the given customer identity to share.
    static func shared(for customerIdentity: Customer?) -> CustomerQueueLogicManager {
        if let logic = queueLogic {
            return logic
        }

        assert(customerIdentity != nil,
               "Customer identity must be given non-nil to make the customer's queue logic manager.")
        let logic = CustomerQueueLogicManager(customer: customerIdentity!)
        logic.queueStorage.queueModificationLogicDelegate = logic

        return logic
    }

    static func deinitShared() {
        queueLogic = nil
    }

    private init(customer: Customer) {
        self.customer = customer
    }

    private var customer: Customer

    var currentQueueRecord: QueueRecord?

    func loadCurrentQueueRecord() {
        // Load the current queue record (if any)
    }

    func enqueue(to restaurant: Restaurant,
                 with groupSize: Int,
                 babyCount: Int,
                 wheelchairCount: Int) -> String? {
        guard currentQueueRecord == nil else {
            // Disallow enqueue if there is a current queue
            // Check if the restaurant is open
            // TODO
            return nil
        }

        let startTime = Date()
        let newRecord = QueueRecord(restaurant: restaurant,
                                    customer: customer,
                                    groupSize: groupSize,
                                    babyCount: babyCount,
                                    wheelchairCount: wheelchairCount,
                                    startTime: startTime,
                                    admitTime: nil,
                                    serveTime: nil)

        currentQueueRecord = newRecord

        //Add the queue record to db
        return nil
    }

    func editQueueRecord(with groupSize: Int,
                         babyCount: Int,
                         wheelchairCount: Int) {
        guard currentQueueRecord != nil else {
            // Check if there is any change
            return
        }
        // Cannot update the restaurant, startTime
        // Reset startTime (??)

        // Update the queue record in db
    }

    func deleteQueueRecord() {
        guard currentQueueRecord != nil else {
            return
        }

        currentQueueRecord = nil

        //Delete the queue record from db
    }

    func restaurantDidAdmitCustomer(record: QueueRecord) {
        guard currentQueueRecord != nil else {
            return
        }

        // Send notification to the user

        currentQueueRecord = nil
    }

    func restaurantDidServeCustomer(record: QueueRecord) {
        //
    }

    func restaurantDidRejectCustomer(record: QueueRecord) {
        //
    }

    func customerDidJoinQueue(with record: QueueRecord) {
        //
    }

    func customerDidUpdateQueueRecord(from old: QueueRecord, to new: QueueRecord) {
        //
    }
    func customerDidWithdrawQueue(record: QueueRecord) {
        //
    }

    // if we allow restaurants to reject customers
    func restaurantDidRemoveQueueRecord(record: QueueRecord) {
        //
    }
}

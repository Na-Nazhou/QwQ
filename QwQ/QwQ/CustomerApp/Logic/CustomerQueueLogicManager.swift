import Foundation

class CustomerQueueLogicManager: CustomerQueueLogic {
    private var queueLogic: CustomerQueueLogicManager?

    static func shared(for customerIdentity: Customer?) -> CustomerQueueLogicManager {
        if let logic = queueLogic {
            return logic
        }

        let logic = CustomerQueueLogicManager(customerIdentity)
        logic.queueStorage.queueModificationLogicDelegate = self
        //TODO: need to check if we are going to have singleton storage; else do we create 1 for custoemr queue logic and 1 for restaurant logic in the customer app?
        return logic
    }

    private init(restaurant: Restaurant) {
        self.restaurant = restaurant
    }

    var queueStorage: CustomerQueueStorage = CustomerQueueStorageStub()

    var currentQueueRecord: CustomerQueueRecord?

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
        let newRecord = CustomerQueueRecord(restaurant: restaurant,
                                            groupSize: groupSize,
                                            babyCount: babyCount,
                                            wheelchairCount: wheelchairCount,
                                            startTime: startTime,
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

    func restaurantDidAdmitCustomer() {
        guard currentQueueRecord != nil else {
            return
        }

        // Send notification to the user

        currentQueueRecord = nil
    }

    func restaurantDidServeCustomer(record: QueueRecord) {
        
    }

    func restaurantDidRejectCustomer(record: QueueRecord) {
        
    }

    
    func customerDidJoinQueue(with record: QueueRecord) {
        
    }
    func customerDidUpdateQueueRecord(from old: QueueRecord, to new: QueueRecord) {
        
    }
    func customerDidWithdrawQueue(record: QueueRecord) {
        
    }
    
    // if we allow restaurants to reject customers
    func restaurantDidRemoveQueueRecord(record: QueueRecord) {
        
    }
}

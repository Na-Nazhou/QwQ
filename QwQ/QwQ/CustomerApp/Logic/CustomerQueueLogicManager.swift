import Foundation

class CustomerQueueLogicManager: CustomerQueueLogic {
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

    func didAdmitCustomer() {
        guard currentQueueRecord != nil else {
            return
        }

        // Send notification to the user

        currentQueueRecord = nil
    }
}

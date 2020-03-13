class CustomerQueueStorageStub: CustomerQueueStorage {
    weak var queueModificationLogicDelegate: QueueStorageSyncDelegate?
    weak var queueStatusLogicDelegate: QueueOpenCloseSyncDelegate?

    func didDetectNewQueueRecord(record: QueueRecord) {
        queueModificationLogicDelegate?.customerDidJoinQueue(with: record)
    }

    func didDetectQueueRecordUpdate(old: QueueRecord, new: QueueRecord) {
        queueModificationLogicDelegate?.customerDidUpdateQueueRecord(from: old, to: new)
    }

    func didDetectWithdrawnQueueRecord(record: QueueRecord) {
        queueModificationLogicDelegate?.customerDidWithdrawQueue(record: record)
    }

    func didDetectAdmissionOfCustomer(record: QueueRecord) {
        queueModificationLogicDelegate?.restaurantDidAdmitCustomer(record: record)
    }

    func didDetectServiceOfCustomer(record: QueueRecord) {
        queueModificationLogicDelegate?.restaurantDidServeCustomer(record: record)
    }

    func didDetectRejectionOfCustomer(record: QueueRecord) {
        queueModificationLogicDelegate?.restaurantDidRejectCustomer(record: record)
    }

    func didDetectOpenQueue(restaurant: Restaurant) {
        queueStatusLogicDelegate?.restaurantDidOpenQueue(restaurant: restaurant)
    }

    func didDetectCloseQueue(restaurant: Restaurant) {
        queueStatusLogicDelegate?.restaurantDidCloseQueue(restaurant: restaurant)
    }

    func addQueueRecord(record: QueueRecord) {
        //firebase add queue
    }

    func updateQueueRecord(old: QueueRecord, new: QueueRecord) {
        //firebase update record
    }

    func deleteQueueRecord(record: QueueRecord) {
        //firebase delete record
    }

    func loadQueueRecord() -> QueueRecord? {
        //firebase get active (current) queue of customer
        return nil
    }
}

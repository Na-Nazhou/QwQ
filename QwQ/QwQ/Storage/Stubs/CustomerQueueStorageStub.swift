class CustomerQueueStorageStub: CustomerQueueStorage {
    func addQueueRecord(record: QueueRecord, completion: @escaping (String) -> Void) {
        completion("-1")
    }

    func updateQueueRecord(old: QueueRecord, new: QueueRecord, completion: @escaping () -> Void) {
        completion()
    }

    func deleteQueueRecord(record: QueueRecord, completion: @escaping () -> Void) {
        completion()
    }

    func loadQueueRecord(customer: Customer) -> QueueRecord? {
        //firebase get active (current) queue of customer
        return nil
    }

    func loadQueueHistory(customer: Customer) -> [QueueRecord] {
        return []
    }

    weak var queueModificationLogicDelegate: QueueStorageSyncDelegate?
    weak var queueStatusLogicDelegate: QueueOpenCloseSyncDelegate?

//    func didDetectNewQueueRecord(record: QueueRecord) {
//        queueModificationLogicDelegate?.customerDidJoinQueue(with: record)
//    }
//
//    func didDetectQueueRecordUpdate(old: QueueRecord, new: QueueRecord) {
//        queueModificationLogicDelegate?.customerDidUpdateQueueRecord(from: old, to: new)
//    }
//
//    func didDetectWithdrawnQueueRecord(record: QueueRecord) {
//        queueModificationLogicDelegate?.customerDidWithdrawQueue(record: record)
//    }

    func didDetectAdmissionOfCustomer(record: QueueRecord) {
        queueModificationLogicDelegate?.restaurantDidAdmitCustomer(record: record)
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
}

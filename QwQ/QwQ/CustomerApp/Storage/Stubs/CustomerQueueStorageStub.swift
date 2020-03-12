class CustomerQueueStorageStub: CustomerQueueStorage {
    weak var queueModificationLogicDelegate: QueueStorageSyncDelegate?
    weak var queueStatusLogicDelegate: QueueOpenCloseSyncDelegate?

    func didDetectNewQueueRecord(record: QueueRecord) {
        //
    }

    func didDetectQueueRecordUpdate(old: QueueRecord, new: QueueRecord) {
        //
    }

    func didDetectWithdrawnQueueRecord(record: QueueRecord) {
        //
    }

    func didDetectAdmissionOfCustomer(record: QueueRecord) {
        //
    }

    func didDetectOpenQueue(restaurant: Restaurant) {
        //
    }

    func didDetectCloseQueue(restaurant: Restaurant) {
        //
    }

    func addQueueRecord(record: QueueRecord) {
    }

    func updateQueueRecord(old: QueueRecord, new: QueueRecord) {
    }

    func deleteQueueRecord(record: QueueRecord) {
    }

    func loadQueueRecord() -> QueueRecord? {
        nil
    }
}

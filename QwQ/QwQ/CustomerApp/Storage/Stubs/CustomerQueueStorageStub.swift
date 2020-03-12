class CustomerQueueStorageStub: CustomerQueueStorage {
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

class CustomerQueueStorageStub: CustomerQueueStorage {
    func addQueueRecord(record: CustomerQueueRecord) {
    }

    func updateQueueRecord(old: CustomerQueueRecord, new: CustomerQueueRecord) {
    }

    func deleteQueueRecord(record: CustomerQueueRecord) {
    }

    func loadQueueRecord() -> CustomerQueueRecord? {
        nil
    }
}

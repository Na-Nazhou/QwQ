protocol CustomerQueueStorageSyncDelegate {
    func didAdmitCustomer()
}

protocol CustomerQueueLogic: CustomerQueueStorageSyncDelegate {
    var queueStorage: CustomerQueueStorage { get set }

    var currentQueueRecord: CustomerQueueRecord? { get set }

    func loadCurrentQueueRecord()

    func enqueue(to restaurant: Restaurant,
                 with groupSize: Int,
                 babyCount: Int,
                 wheelchairCount: Int) -> String?

    func editQueueRecord(with groupSize: Int,
                         babyCount: Int,
                         wheelchairCount: Int)

    func deleteQueueRecord()
}

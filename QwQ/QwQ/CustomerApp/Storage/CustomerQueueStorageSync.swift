protocol CustomerQueueStorageSync {
    var logicDelegate: CustomerQueueStorageSyncDelegate? { get set }

    /// Notify when customer is admitted (timeServed updated)
    func didAdmitCustomer()
}

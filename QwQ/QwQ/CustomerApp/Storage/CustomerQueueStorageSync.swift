protocol CustomerQueueStorageSync {
    var logicDelegate: CustomerQueueStorageSyncDelegate? { get set }

    /// Notify when customer is admitted (update in timeServed)
    func didAdmitCustomer()
}

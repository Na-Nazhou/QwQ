protocol CustomerQueueStorageSyncDelegate: AnyObject {
    func restaurantDidAdmitCustomer(_ customer: Customer)
    func restaurantDidServeCustomer(_ customer: Customer)
    func restaurantDidRejectCustomer(_ customer: Customer)

    func customerDidJoinQueue(with record: CustomerQueueRecord)
    func customerDidWithdrawQueue(record: CustomerQueueRecord)
    func customerDidUpdateQueueRecord(from old: CustomerQueueRecord, to new: CustomerQueueRecord)
}

protocol CustomerQueueStorageSync {
    var logicDelegate: CustomerQueueStorageSyncDelegate? { get set }

    // MARK: - Sync handlers
    // may remove this section if fb handlers are to be rewritten
    // current state is just wrappers over delegate
    // storage will need to process the change detected to give the required arguments
    func didDetectNewCustomerInQueue(record: CustomerQueueRecord)
    func didDetectCustomerWithdrawQueue(record: CustomerQueueRecord)
    func didDetectModificationOfQueueRecord(old: CustomerQueueRecord, new: CustomerQueueRecord)
    
    /// Notify when customer is admitted (timeServed updated), if in-app notif
    func didDetectAdmissionOfCustomer(record: CustomerQueueRecord)
    func didDetectServiceOfCustomer(record: CustomerQueueRecord)
    func didDetectRejectionOfCustomer(record: CustomerQueueRecord)
}

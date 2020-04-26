/// Represents the protocol any booking storage syncing delegates need to conform to.
protocol BookingStorageSyncDelegate: AnyObject {

    /// Adds record to collection of book records.
    func didAddBookRecord(_ record: BookRecord)

    /// Updates collection of book records when updated. 
    func didUpdateBookRecord(_ record: BookRecord)

}

/// Represents the protocol any booking storage syncing delegates need to conform to.
protocol BookingStorageSyncDelegate: AnyObject {

    /// Updates collection of book records when updated. 
    func didUpdateBookRecord(_ record: BookRecord)

}

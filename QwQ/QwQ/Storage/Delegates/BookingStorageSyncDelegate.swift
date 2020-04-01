protocol BookingStorageSyncDelegate: AnyObject {

    /// Updates collection of book records when added or details updated.
    func didUpdateBookRecord(_ record: BookRecord)

}
